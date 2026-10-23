# Laboratorio S05 · Del CSV a la tabla Delta

**Duración:** 40 min · **Modalidad:** individual · **Entregable:** `evidencia-s05.md`
**Requisito:** el storage de S04 con los cinco CSV en `bronze/pedidos/fecha_carga=2026-10-10/` y un workspace de Databricks con Unity Catalog.

**Plan B:** si tu workspace no aprovisiona cómputo, usa el **SQL warehouse** y completa la misma evidencia. El workspace del instructor en East US tiene serverless y el catálogo `pede` ya cargado para la demo en vivo.

## Qué vas a demostrar

Al terminar vas a tener cinco tablas Delta externas en `pede.bronze`, legibles desde SQL, con columnas de auditoría y conteos verificados. Los archivos siguen en tu lago: no se copiaron al workspace.

## Antes de empezar

| Pieza | Dónde se crea | Para qué |
|---|---|---|
| Access connector | Portal de Azure | Identidad administrada que lee el storage |
| Rol `Storage Blob Data Contributor` | Storage account → IAM | Autoriza al conector sobre el lago |
| Storage credential | Databricks → Catalog → Credentials | Envuelve al conector para Unity Catalog |
| External location | Databricks → Catalog → External locations | Autoriza la ruta `abfss://bronze@...` |
| Catálogo `pede` | Databricks → Catalog | Namespace de las tablas |
| Key Vault + secreto | Portal de Azure | Secreto de práctica (no se usa para el lago) |
| Scope `kv-pede` | Databricks → Secrets | Puente de lectura al vault |

## Paso 1 · Verifica el acceso al lago (5 min)

Abre el **SQL Editor**, elige el SQL warehouse y ejecuta:

```sql
SELECT COUNT(*) AS filas
FROM read_files(
  'abfss://bronze@<tu-storage>.dfs.core.windows.net/pedidos/fecha_carga=2026-10-10/orders.csv',
  format => 'csv', header => true, inferSchema => true
);
```

**Verificación:** 10 filas. Si devuelve 0, la ruta o la fecha están mal. Si devuelve `PERMISSION_DENIED`, falta el rol del access connector.

## Paso 2 · Crea la tabla Delta externa (10 min)

```sql
CREATE OR REPLACE TABLE pede.bronze.orders
USING DELTA
LOCATION 'abfss://bronze@<tu-storage>.dfs.core.windows.net/delta/orders'
AS
SELECT *,
       'abfss://bronze@<tu-storage>.dfs.core.windows.net/pedidos/fecha_carga=2026-10-10/orders.csv' AS _source_file,
       '2026-10-10' AS _load_date,
       current_timestamp() AS _ingested_at
FROM read_files(
  'abfss://bronze@<tu-storage>.dfs.core.windows.net/pedidos/fecha_carga=2026-10-10/orders.csv',
  format => 'csv', header => true, inferSchema => true
);
```

**Verificación:** en **Catalog → pede → bronze → orders**, la tabla dice **External** y formato **Delta**.

## Paso 3 · Carga las cinco tablas (10 min)

Repite el Paso 2 para `customers`, `products`, `order_items` y `payments`. Cambia solo el nombre de la tabla y del archivo.

**Verificación:** las cinco aparecen en `pede.bronze`.

## Paso 4 · Valida los conteos (5 min)

```sql
SELECT 'customers' AS tabla, COUNT(*) AS filas FROM pede.bronze.customers
UNION ALL SELECT 'products',    COUNT(*) FROM pede.bronze.products
UNION ALL SELECT 'orders',      COUNT(*) FROM pede.bronze.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM pede.bronze.order_items
UNION ALL SELECT 'payments',    COUNT(*) FROM pede.bronze.payments
ORDER BY tabla;
```

**Esperado:** customers 5 · products 8 · orders 10 · order_items 15 · payments 9.

## Paso 5 · Consulta de negocio y linaje (7 min)

```sql
-- Pedidos por canal y estado
SELECT channel AS canal, status AS estado, COUNT(*) AS pedidos
FROM pede.bronze.orders
GROUP BY channel, status
ORDER BY pedidos DESC;

-- Total pagado
SELECT ROUND(SUM(amount), 2) AS total_pagado FROM pede.bronze.payments;

-- Versiones de la tabla
DESCRIBE HISTORY pede.bronze.orders;
```

**Esperado:** 6 pedidos web pagados, 3 de tienda pagados, 1 web cancelado; total pagado 13.158,50.

## Paso 6 · Lee el secreto sin exponerlo (3 min)

En un notebook con cualquier cómputo disponible:

```python
print([s.name for s in dbutils.secrets.listScopes()])
token = dbutils.secrets.get(scope="kv-pede", key="pede-demo-secret")
print(token)       # [REDACTED]
print(len(token))  # solo la longitud
```

**Verificación:** el valor nunca aparece en la salida.

## Evidencia (`evidencia-s05.md`)

Incluye:

1. La salida de los cinco conteos.
2. Captura de `pede.bronze.orders` mostrando **External** y **Delta**.
3. Captura del historial de la tabla (al menos una versión).
4. La salida de la consulta por canal y estado.
5. Una frase: ¿por qué el acceso al lago no usa el secreto de Key Vault?

## Errores frecuentes

| Error | Causa | Qué hacer |
|---|---|---|
| 0 filas | Fecha o nombre de archivo incorrectos | Revisar `fecha_carga=2026-10-10` |
| `PERMISSION_DENIED` | Falta el rol del conector | Asignar `Storage Blob Data Contributor` |
| `PATH_NOT_FOUND` | La external location no cubre la ruta | Revisar la URL de `ext_pede_bronze` |
| `SECRET_NOT_FOUND` | Scope o key mal escritos | Listar scopes y secretos, sin imprimir valores |
| La tabla no aparece | Se escribió el archivo pero no se registró | Crear la tabla con `LOCATION` |
| El clúster queda en Pending | El workspace no aprovisiona cómputo | Usar serverless (East US) o el SQL warehouse |
