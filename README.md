# P.E. Data Engineer · Azure — Material para alumnos

Módulo Azure del curso **Cloud Computing** del P.E. Data Engineer Multicloud (DSRP), dictado por Manuel Argüelles.

## Cómo usar este repositorio
GitHub muestra los archivos `.html` como código. Para verlos funcionando:

1. Pulsa **Code → Download ZIP** (o clona el repositorio) y descomprime **toda** la carpeta: el deck necesita las carpetas `assets/`, `capturas/`, `herramientas/` y `guias/` junto a él.
2. Abre **`index.html`** en la raíz y entra a cualquier sesión desde ahí. También puedes abrir directamente `sesion-05/S05-deck.html`. Funciona sin conexión, salvo los enlaces a páginas de Microsoft y otras fuentes.

## Sesión 1 · Introducción a la nube

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](sesion-01/S01-deck.html) | 38 slides; avanza con las flechas o con clic. |
| [Generador de nombres Azure](sesion-01/herramientas/generador-nombres.html) | Calcula y valida los nombres de tus recursos. El botón **Generar la solución completa** copia, listo para pegar en tu ficha, la tabla de los 7 nombres del paso 2 y las 5 etiquetas. |
| [Consigna del laboratorio](sesion-01/lab/CONSIGNA.md) | Los 6 pasos del lab (25 min). |
| [Plantilla de la ficha](sesion-01/lab/plantilla-ficha.md) | Lo que entregas. |
| [Sistema de nombres del curso](sesion-01/guias/00-sistema-de-naming.md) | Cómo se forma cada nombre y por qué. |
| [Guía del portal de Azure (Windows)](sesion-01/guias/01-guia-portal-azure-windows.md) | Paso a paso con capturas. |
| [Crear tu cuenta Azure Free Trial](sesion-01/guias/02-crear-cuenta-azure-free-trial.md) | Alta de la cuenta gratuita. |

**Importante:** hoy solo creas un grupo de recursos (vacío, sin costo). No borres tu grupo: lo usaremos en el Módulo 2.

## Sesión 2 · Datos en Azure y Azure SQL Database

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](sesion-02/S02-deck.html) | 58 slides: tipos de dato, Azure SQL, laboratorio, Cosmos DB, firewall y conexión con SSMS/DBeaver. |
| [Consigna del laboratorio](sesion-02/lab/CONSIGNA.md) | Pasos, tiempos, aceptación y errores frecuentes. |
| [Plantilla de entrega](sesion-02/lab/plantilla-entrega.md) | Formato de `entrega-lab01.md`. |
| [Esquema](sesion-02/lab/esquema-lab01.sql) · [Carga](sesion-02/lab/carga-datos.sql) · [Validación](sesion-02/lab/consultas-validacion.sql) | Scripts de referencia del laboratorio. |
| [Datos](sesion-02/lab/datos/) | Los cinco CSV sintéticos de Andina Retail. |

**Importante:** el servidor es compartido y cada alumno tiene su propio **usuario y schema**. Usa los scripts personalizados que recibiste por correo; los scripts del repo usan `dbo` solo como referencia. No uses el login del instructor.

## Sesión 3 · Big Data, lago y lakehouse

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](sesion-03/S03-deck.html) | 31 slides: Big Data, 4 V, ciclo de vida, formatos, warehouse/lake/lakehouse y arquitectura. |
| [Consigna del laboratorio](sesion-03/lab/CONSIGNA.md) | Diseño de lakehouse para Andina, 35 min. |
| [Plantilla de diseño](sesion-03/lab/plantilla-diseno.md) | Formato de `entrega-s03.md`. |

**Idea central:** S03 decide la arquitectura; S04 construye ADLS Gen2, las zonas y las ACL.

## Sesión 4 · Data lake y ADLS Gen2

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](sesion-04/S04-deck.html) | 21 slides: Blob vs ADLS, HNS, zonas, RBAC/ACL y ciclo de vida. |
| [Consigna del laboratorio](sesion-04/lab/CONSIGNA.md) | Crear cuenta ADLS, contenedores, cargar CSV y probar permisos. |
| [Plantilla de evidencia](sesion-04/lab/plantilla-evidencia.md) | Formato de `evidencia-s04.md`. |

No subas aquí datos personales, claves ni tokens.

## Sesión 5 · ADLS aplicado, secretos y Databricks

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](sesion-05/S05-deck.html) | 34 slides: workspace y cómputo, Unity Catalog, Key Vault y tablas Delta. |
| [Consigna del laboratorio](sesion-05/lab/CONSIGNA.md) | Leer el bronce y crear las cinco tablas Delta, 40 min. |
| [Plantilla de evidencia](sesion-05/lab/plantilla-evidencia.md) | Formato de `evidencia-s05.md`. |
| [Guía visual paso a paso](sesion-05/guias/01-guia-databricks-uc-paso-a-paso.md) | Conexión del lago con Unity Catalog y capturas reales. |

**Idea central:** el lago ya tiene los datos; S05 le da cómputo y gobierno. El laboratorio funciona con el SQL warehouse, sin crear un clúster.

## Sesión 6 · Consolidación bronce → plata y Databricks SQL

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](sesion-06/S06-deck.html) | 31 slides: grano, joins, calidad, Databricks SQL, jobs y linaje. |
| [Consigna del laboratorio](sesion-06/lab/CONSIGNA.md) | Construir la tabla plata y programar el job, 40 min. |
| [Plantilla de evidencia](sesion-06/lab/plantilla-evidencia.md) | Formato de `evidencia-s06.md`. |
| [Script SQL](sesion-06/lab/02_silver.sql) | La consolidación completa. |
| [Guía visual](sesion-06/guias/01-guia-bronce-a-plata-y-job.md) | Paso a paso del job y las validaciones. |

**Idea central:** la plata une el bronce con un grano explícito; el job lo convierte en proceso observable.
