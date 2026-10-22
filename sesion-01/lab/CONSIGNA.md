# Laboratorio · Módulo 1 · Ficha de decisión de nube y primer grupo de recursos

**Duración:** 25 min · **Modalidad:** individual · **Entregables:** (1) un grupo de recursos en Azure con nombre y etiquetas según el sistema del curso (`guias/00-sistema-de-naming.md`), (2) `ficha-decision-nube.md` (usa `plantilla-ficha.md`).
**Importante:** no crees ningún otro recurso de Azure hoy. Un grupo de recursos vacío no tiene costo; la calculadora de precios solo estima, no cobra.

## El caso: Andina Retail (empresa ficticia)
Cadena de 40 tiendas. Hoy guarda las ventas en un SQL Server en un servidor propio. Tiene picos de demanda en campañas (Navidad, Cyber). Maneja datos personales de clientes (en Perú aplica la Ley 29733). Quiere hacer analítica y, más adelante, IA. El equipo conoce SQL Server y no ha operado nube antes.

| # | Paso | Tiempo | Qué haces | Aceptación observable |
|---|---|---|---|---|
| 1 | Portal y suscripción | 3 min | Ingresa a https://portal.azure.com, busca «Subscriptions» y ubica la tuya. | Captura donde se vea el nombre de la suscripción (tapa el identificador). |
| 2 | Nombres y grupo de recursos | 7 min | Abre `herramientas/generador-nombres.html`, escribe tu token de alumno, elige región y copia el nombre del grupo. Crea el grupo con las 5 etiquetas del sistema de nombres y anota por qué elegiste esa región. | El grupo aparece en «Resource groups» con su nombre generado y las 5 etiquetas; en la ficha pegaste la tabla de los 7 nombres del set. |
| 3 | IaaS, PaaS, SaaS | 4 min | Clasifica estos 8: Virtual Machines · Virtual Network · Azure SQL Database · Azure App Service · Azure Functions · Microsoft 365 · Power BI · Azure Databricks. | Tabla completa en la ficha, al menos 7 de 8 coinciden con la clave del instructor. |
| 4 | Calculadora de precios | 4 min | En https://azure.microsoft.com/pricing/calculator/ estima una cuenta de almacenamiento de 1 TB (1000 GB) en tu región. | Ficha con enlace o captura, **fecha de la estimación** y supuestos (nivel de acceso, redundancia, estructura de archivos). |
| 5 | Equivalencias | 4 min | Completa 3 filas de la tabla de equivalencias entre AWS, Azure y Google Cloud (documentación oficial de cada una). | 3 filas completas, con el nombre real del servicio en cada nube. |
| 6 | Ficha de decisión | 3 min | Recomienda un modelo de despliegue para Andina Retail. | La ficha cita **al menos 3 criterios** de la matriz (slide 28), 2 ventajas, 2 riesgos y 1 mitigación. |

**Duración total:** 25 min. **Guía con capturas (Windows):** `guias/01-guia-portal-azure-windows.md`.

## Si no puedes crear cuenta o suscripción
Sigue en vivo el paso 2 que haga el instructor, escribe en la ficha el nombre y la región que habrías usado, y haz los pasos 3 a 6 con normalidad (no necesitan nube).

## Tarea para el Módulo 2
Escribe 3 ejemplos de datos de tu trabajo y clasifica cada uno como estructurado, semiestructurado o no estructurado, con una frase de justificación. **Aceptación:** 3 ejemplos clasificados y justificados, listos para compartir al inicio de la próxima sesión. **No borres tu grupo de recursos.**
