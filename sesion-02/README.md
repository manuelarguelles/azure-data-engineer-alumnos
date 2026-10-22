# Sesión 2 · Datos en Azure y Azure SQL Database

Material público de la sesión. El acceso al servidor es personal: cada alumno recibe por correo su usuario, contraseña y schema.

## Contenido

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](S02-deck.html) | 58 slides: tipos de dato, Azure SQL, laboratorio, Cosmos DB, firewall y conexión con SSMS/DBeaver. |
| [Consigna del laboratorio](lab/CONSIGNA.md) | Pasos, tiempos, aceptación y errores frecuentes. |
| [Plantilla de entrega](lab/plantilla-entrega.md) | Formato de `entrega-lab01.md`. |
| [Esquema](lab/esquema-lab01.sql) | DDL de las cinco tablas (versión de referencia con `dbo`). |
| [Carga](lab/carga-datos.sql) | INSERT explícitos y transacción (versión de referencia). |
| [Validación](lab/consultas-validacion.sql) | Conteos, total y diferencias de pago. |
| [Datos](lab/datos/) | Los cinco CSV sintéticos de Andina Retail. |

## Importante: usa tus scripts personalizados

El correo de accesos incluye tus scripts con **tu schema**. Úsalos. Los scripts de este repositorio usan `dbo` solo como referencia del instructor; si los ejecutas tal cual, intentarías escribir en un espacio que no es el tuyo.

Si solo tienes los scripts del repo, reemplaza `dbo.` por `[tu_usuario].` antes de ejecutarlos.

## Conexión

Los datos exactos de servidor, base, usuario y contraseña están en tu correo de accesos. No los publiques ni los compartas.

- **DBeaver:** conexión SQL Server, puerto `1433`, SQL Server Authentication.
- **SSMS (Windows):** `tcp:<servidor>,1433` si aparece error `53/40`.
- **Sin instalar nada:** Query editor del portal con tu usuario.

Si aparece `40615`, tu IP no está habilitada: responde el correo con tu IPv4 de <https://api.ipify.org>.

## Reglas

- No subas contraseñas, tokens ni datos personales al repositorio.
- No borres el servidor ni la base.
- Tu usuario solo puede crear y leer objetos en tu schema.
