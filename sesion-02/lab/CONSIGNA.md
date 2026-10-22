# Laboratorio 01 · Base e-commerce en Azure SQL Database

**Duración:** 60 min · **Modalidad:** individual · **Entregable:** `entrega-lab01.md`

**Requisito:** haber recibido el correo **«[ACCIÓN REQUERIDA] Activa tu acceso al laboratorio Azure SQL · S02»** con tu servidor, base, usuario, contraseña y schema. El servidor y la base ya están creados: **no crees un servidor ni una base nuevos** y no uses el login del instructor.

**Regla de oro:** si un paso falla y no se resuelve en 10 minutos, pega el error exacto en el chat y sigue con el paso siguiente.

## Qué vas a demostrar

Al terminar vas a tener tus cinco tablas en tu schema, los datos cargados y una consulta de negocio validada contra un resultado esperado. No alcanza con que la base exista: los números tienen que coincidir.

## Antes de empezar (5 min)

1. Abre el correo de accesos y localiza tu **usuario** y tu **schema** (son el mismo nombre).
2. Instala **DBeaver** (Mac/Windows) o **SSMS** (solo Windows). Si no puedes instalar nada, usa el **Query editor** del portal.
3. Ten a mano los scripts personalizados que recibiste. Si no los encuentras, avisa al instructor.
4. Comprueba que tu IP ya esté habilitada. Si al conectar ves `40615` o timeout, responde al correo con tu **IPv4** de <https://api.ipify.org>.

## Paso 1 · Conectarte (10 min)

| Campo | Valor |
|---|---|
| Server | `sql-pede-nix-dev-brs-001.database.windows.net` |
| Port | `1433` |
| Database | `sqldb-pede-demo-dev-brs-001` |
| Authentication | SQL Server Authentication |
| Login | tu usuario del correo |
| Password | la del correo |
| Schema por defecto | tu usuario del correo |

**SSMS:** no dejes **Database Name** en `<default>`; selecciona `sqldb-pede-demo-dev-brs-001`. Si lo dejas en `<default>`, el login intenta abrir `master` y aparece el error `916`.

Si aparece el error `53 / 40`, usa el nombre así:

```text
tcp:sql-pede-nix-dev-brs-001.database.windows.net,1433
```

**DBeaver:** crea una conexión **SQL Server**. Si no ves tu schema, activa **Show All Schemas** en la configuración de la conexión.

**Verificación** en el editor SQL:

```sql
SELECT SUSER_SNAME() AS login, SCHEMA_NAME() AS schema_actual;
```

Debe devolver tu usuario y tu schema.

## Paso 2 · Crear tus tablas (10 min)

Ejecuta **tu `esquema-lab01.sql` personalizado**. Crea `customers`, `products`, `orders`, `order_items` y `payments` dentro de tu schema.

Si estás usando el script genérico del repositorio, antes de ejecutarlo reemplaza `dbo.` por `[tu_usuario].`. No ejecutes el script genérico tal cual: crearía las tablas en `dbo`, que es la referencia del instructor y no tu espacio.

**Verificación:**

```sql
SELECT name FROM sys.tables WHERE schema_id = SCHEMA_ID();
```

Deben aparecer tus cinco tablas.

## Paso 3 · Cargar los datos (10 min)

Ejecuta **tu `carga-datos.sql` personalizado**. Usa una transacción: si una fila falla, no queda media carga.

**Verificación rápida:**

```sql
SELECT 'customers' AS tabla, COUNT(*) AS filas FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments;
```

Esperado: `customers 5`, `products 8`, `orders 10`, `order_items 15`, `payments 9`.

## Paso 4 · Ejecutar y validar la consulta de negocio (15 min)

Ejecuta **tu `consultas-validacion.sql` personalizado**. Responde: **¿cuánto pagó cada cliente por método de pago?**

Resultado esperado: **8 filas** y un total general de **13.158,50**.

Después corre la última consulta del archivo (diferencias entre `payments.amount` y la suma de líneas). Esperado: **0 filas**.

## Entregable `entrega-lab01.md`

Completa `plantilla-entrega.md` con:

1. Los cinco conteos.
2. El resultado de la consulta por cliente y método (copiado como tabla, no captura).
3. El total pagado y la cantidad de filas.
4. Dos líneas que expliquen por qué el pedido 1007 no aparece en el resultado.
5. Una decisión: ¿este caso podría vivir en Cosmos DB? Justifica con la pregunta de negocio.

## Errores frecuentes

| Error | Causa probable | Qué hacer |
|---|---|---|
| 40615 / timeout | Tu IP no está permitida en el firewall | Responde el correo con tu IPv4 de <https://api.ipify.org> |
| 18456 | Login o contraseña incorrectos | Revisa tu usuario del correo, no el del instructor |
| 53 / 40 | SSMS no pudo abrir TCP: nombre, DNS o puerto 1433 bloqueado | Usa `tcp:...database.windows.net,1433`; prueba otra red/hotspot |
| 547 | Clave foránea: cargaste una tabla hija antes que la padre | Corre tu esquema y después tu carga |
| 2627 | Clave primaria duplicada | Ya cargaste datos; vuelve a correr el esquema y la carga |
| 8114 | Tipo o columna desalineada | Revisa el orden de las columnas del INSERT |
| El total da 13.407,50 | Incluiste el pedido cancelado o multiplicaste líneas | Revisa el `WHERE o.status = 'pagado'` y los JOIN |

## Plan B sin instalar nada

1. Abre la base en el portal → **Query editor**.
2. Inicia sesión con **tu usuario y contraseña** (no con el admin).
3. Pega y ejecuta tus scripts personalizados en orden.
4. Si el editor no está disponible, comparte pantalla con el instructor.

## Seguridad y limpieza

- No compartas tu contraseña ni la dejes en un archivo dentro del repositorio.
- No borres el servidor ni la base: son la fuente del pipeline del proyecto final.
- Tu usuario solo puede crear y leer objetos en **tu schema**. No puede tocar `dbo` ni los schemas de tus compañeros.
- Si cambias de red y tu IP cambia, vuelve a enviarla para actualizar el firewall.
