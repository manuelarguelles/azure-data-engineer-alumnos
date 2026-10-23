# Databricks notebook source
# MAGIC %md
# MAGIC # S05 · Carga de la capa bronce en Delta
# MAGIC
# MAGIC **Curso:** P.E. Data Engineer · Azure · **Sesión 05**
# MAGIC
# MAGIC **Objetivo:** leer los cinco CSV de Andina Retail desde ADLS Gen2 con Unity Catalog,
# MAGIC agregar columnas de auditoría y dejarlos como tablas Delta en `pede.bronze`.
# MAGIC
# MAGIC **Conteos esperados:** customers 5 · products 8 · orders 10 · order_items 15 · payments 9.
# MAGIC
# MAGIC > El acceso al lake lo resuelve la *storage credential* `cred-pede-brs` (identidad administrada).
# MAGIC > En este notebook no hay claves ni contraseñas: solo el nombre del secreto.

# COMMAND ----------

# MAGIC %md
# MAGIC ## 1 · Parámetros del laboratorio
# MAGIC Cambia solo estos valores si tu cuenta o tu fecha de carga son distintas.

# COMMAND ----------

dbutils.widgets.text("storage_account", "stpededemobrs001", "Cuenta de storage")
dbutils.widgets.text("load_date", "2026-10-10", "Fecha de carga (YYYY-MM-DD)")

STORAGE = dbutils.widgets.get("storage_account")
LOAD_DATE = dbutils.widgets.get("load_date")
CONTAINER = "bronze"
RAW_PATH = f"abfss://{CONTAINER}@{STORAGE}.dfs.core.windows.net/pedidos/fecha_carga={LOAD_DATE}"
DELTA_PATH = f"abfss://{CONTAINER}@{STORAGE}.dfs.core.windows.net/delta"

print("Ruta de origen:", RAW_PATH)
print("Ruta Delta:", DELTA_PATH)
display(dbutils.fs.ls(RAW_PATH))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 2 · Leer el secreto sin exponerlo
# MAGIC El scope `kv-pede` está respaldado por Azure Key Vault. `dbutils.secrets.get` devuelve el valor,
# MAGIC pero Databricks lo redacta en la salida. La prueba es que **no** se ve el valor.

# COMMAND ----------

print("Scopes disponibles:", [s.name for s in dbutils.secrets.listScopes()])
print("Secretos en kv-pede:", [s.key for s in dbutils.secrets.list("kv-pede")])

demo_secret = dbutils.secrets.get(scope="kv-pede", key="pede-demo-secret")
print("Valor del secreto:", demo_secret)
print("Longitud:", len(demo_secret))

# COMMAND ----------

# MAGIC %md
# MAGIC ## 3 · Leer cada CSV y agregar columnas de auditoría
# MAGIC
# MAGIC `_source_file` permite reconstruir de dónde salió cada fila.
# MAGIC `_load_date` identifica la partición lógica.
# MAGIC `_ingested_at` registra el momento de la carga.

# COMMAND ----------

from pyspark.sql import functions as F

TABLES = ["customers", "products", "orders", "order_items", "payments"]

def normalize_columns(df):
    clean = [c.strip().lower().replace(" ", "_").replace("-", "_") for c in df.columns]
    return df.toDF(*clean)

def read_csv(table):
    path = f"{RAW_PATH}/{table}.csv"
    df = (spark.read
          .option("header", "true")
          .option("inferSchema", "true")
          .option("delimiter", ",")
          .csv(path))
    return (normalize_columns(df)
            .withColumn("_source_file", F.lit(path))
            .withColumn("_load_date", F.lit(LOAD_DATE))
            .withColumn("_ingested_at", F.current_timestamp()))

for table in TABLES:
    df = read_csv(table)
    print(f"{table}: {df.count()} filas · {len(df.columns)} columnas")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 4 · Escribir Delta y registrar la tabla externa
# MAGIC Los archivos Delta quedan en el lake (`bronze/delta/<tabla>`), no en el almacenamiento interno
# MAGIC de Databricks. La tabla del catálogo solo apunta a esa ruta.

# COMMAND ----------

spark.sql("CREATE SCHEMA IF NOT EXISTS pede.bronze")

for table in TABLES:
    df = read_csv(table)
    target = f"{DELTA_PATH}/{table}"
    (df.write
       .format("delta")
       .mode("overwrite")
       .option("overwriteSchema", "true")
       .save(target))
    spark.sql(f"""
        CREATE TABLE IF NOT EXISTS pede.bronze.{table}
        USING DELTA
        LOCATION '{target}'
    """)
    spark.sql(f"REFRESH TABLE pede.bronze.{table}")
    print(f"OK pede.bronze.{table} -> {target}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 5 · Verificar los conteos
# MAGIC Si algún número no coincide, revisa la ruta y el archivo antes de seguir.

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT 'customers' AS tabla, COUNT(*) AS filas FROM pede.bronze.customers
# MAGIC UNION ALL SELECT 'products', COUNT(*) FROM pede.bronze.products
# MAGIC UNION ALL SELECT 'orders', COUNT(*) FROM pede.bronze.orders
# MAGIC UNION ALL SELECT 'order_items', COUNT(*) FROM pede.bronze.order_items
# MAGIC UNION ALL SELECT 'payments', COUNT(*) FROM pede.bronze.payments
# MAGIC ORDER BY tabla;

# COMMAND ----------

# MAGIC %md
# MAGIC ## 6 · Primera consulta de negocio
# MAGIC Pedidos por canal y estado: el negocio ya puede responder sin tocar el CSV.

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT channel AS canal, status AS estado, COUNT(*) AS pedidos
# MAGIC FROM pede.bronze.orders
# MAGIC GROUP BY channel, status
# MAGIC ORDER BY pedidos DESC;

# COMMAND ----------

# MAGIC %md
# MAGIC ## 7 · Linaje y versiones
# MAGIC Delta guarda el historial: cada escritura es una versión que se puede auditar.

# COMMAND ----------

display(spark.sql("DESCRIBE HISTORY pede.bronze.orders"))
