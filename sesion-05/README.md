# Sesión 5 · ADLS aplicado, secretos y Databricks

| Recurso | Qué es |
|---|---|
| [Deck de la sesión](S05-deck.html) | 34 slides: workspace y cómputo, Unity Catalog, Key Vault, Delta y laboratorio. |
| [Consigna del laboratorio](lab/CONSIGNA.md) | Leer el bronce y crear las cinco tablas Delta, 40 min. |
| [Plantilla de evidencia](lab/plantilla-evidencia.md) | Formato de `evidencia-s05.md`. |
| [Notebook de referencia](lab/notebooks/01_load_bronze_andina.py) | La misma carga con PySpark, para cuentas con clúster. |
| [Guía visual paso a paso](guias/01-guia-databricks-uc-paso-a-paso.md) | Conexión del lago con Unity Catalog, Key Vault y capturas reales. |

**Idea central:** el lago ya tiene los datos; S05 le da cómputo y gobierno. Unity Catalog resuelve el acceso con identidad, Key Vault resuelve los secretos de aplicación y Delta deja el bronce consultable.

**Nota:** el laboratorio se puede completar con el SQL warehouse del workspace, sin crear un clúster.

No subas contraseñas, tokens ni datos personales.
