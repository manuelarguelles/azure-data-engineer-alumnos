# Sistema de nombres del curso · P.E. Data Engineer · Azure

> Basado en la convención del Cloud Adoption Framework de Microsoft (abreviaturas oficiales) y en las reglas de nombres de Azure Resource Manager, ambas **verificadas el 19-oct-2026**. Las partes marcadas «convención del curso» son decisiones nuestras, no reglas de Azure.

## Por qué un sistema
Un nombre bien formado responde cinco preguntas sin abrir el recurso: **qué es, de quién es, para qué sirve, en qué entorno está y dónde vive**. Además, varios nombres deben ser **únicos en todo Azure** porque forman una dirección de internet (`<nombre>.blob.core.windows.net`). Si cada alumno inventa los suyos, chocan, y nadie entiende el portal del otro.

## Patrón
```
<tipo>-<carga>-<alumno>-<entorno>-<región>-<instancia>
```
| Parte | Qué es | Valores en el curso | Origen |
|---|---|---|---|
| `tipo` | Abreviatura del recurso | `rg` `st` `sql` `sqldb` `adf` `dbw` `kv` `log` `id` | Microsoft CAF |
| `carga` | Proyecto o carga de trabajo | `pede` | convención del curso |
| `alumno` | Quién es el dueño (garantiza unicidad) | 3 a 6 letras/números: inicial del nombre + apellido, sin tildes ni ñ. Ej.: Manuel Argüelles → `margue` | convención del curso |
| `entorno` | Etapa | `dev` (en el curso solo se usa `dev`) | convención del curso |
| `región` | Código corto de la región | `brs` Brazil South · `eus` East US · `eus2` East US 2 · `cus` Central US · `scus` South Central US · `wus2` West US 2 · `chc` Chile Central | convención del curso |
| `instancia` | Contador de tres cifras | `001`; si el nombre global ya existe, `002`… | convención del curso |

## Nombres por recurso (ejemplo con alumno `margue`, región `brs`)
| Recurso | Nombre | Alcance de unicidad | Largo | Caracteres válidos (Azure) |
|---|---|---|---|---|
| Grupo de recursos | `rg-pede-margue-dev-brs-001` | suscripción | 1-90 | letras, números, `_ - . ( )`; no termina en punto |
| Cuenta de almacenamiento / ADLS Gen2 | `stpedemarguedldevbrs001` ⁽¹⁾ | **global** | 3-24 | solo minúsculas y números |
| Servidor Azure SQL | `sql-pede-margue-dev-brs-001` | **global** | 1-63 | minúsculas, números y guiones; no empieza ni termina en guion |
| Base de datos Azure SQL | `sqldb-andina-ventas-dev` | servidor | 1-63 | letras, números y guiones (convención: `sqldb-<dominio>-<tema>-<entorno>`) |
| Azure Data Factory | `adf-pede-margue-dev-brs-001` | **global** | 3-63 | letras, números y guiones; empieza y termina en letra o número |
| Workspace de Databricks | `dbw-pede-margue-dev-brs-001` | grupo de recursos | 3-64 | letras, números, `_` y `-` |
| Key Vault | `kv-pede-margue-dev-001` ⁽²⁾ | **global** | 3-24 | letras, números y guiones; empieza con letra, termina en letra o número; sin guiones seguidos |
| Log Analytics | `log-pede-margue-dev-brs-001` | grupo de recursos | 4-63 | letras, números y guiones; empieza y termina en letra o número |
| Identidad administrada | `id-adf-pede-margue-dev-001` | grupo de recursos | 3-128 | letras, números, guiones y `_`; empieza con letra o número |

⁽¹⁾ El almacenamiento no admite guiones: se escribe `st` + `pede` + `alumno` + `dl` (data lake) + `entorno` + `región` + `instancia`, todo junto. Con alumno de 6 letras queda en 23 caracteres, dentro del límite de 24.
⁽²⁾ Key Vault admite solo 24 caracteres: se omite la región para no pasarse.

## Dentro de los servicios (convención del curso)
| Dónde | Regla | Ejemplo |
|---|---|---|
| Contenedores de ADLS | Capas medallón en minúsculas | `bronze` · `silver` · `gold` |
| Carpetas del lake | `origen=<sistema>/tabla=<tabla>/fecha=AAAA-MM-DD` | `origen=sql/tabla=users/fecha=2026-10-19` |
| Archivos | `<dominio>_<tabla>_<AAAAMMDD>.csv` | `andina_users_20261019.csv` |
| Data Factory: pipelines | `pl_<origen>_a_<destino>_<acción>` | `pl_sql_a_adls_copiar_tablas` |
| Data Factory: datasets | `ds_<sistema>_<objeto>` | `ds_sql_ventas` · `ds_adls_csv_bronze` |
| Data Factory: linked services | `ls_<sistema>` | `ls_sql_ventas` · `ls_adls_dl` · `ls_kv` |
| Data Factory: triggers | `tr_<frecuencia>_<hora>` | `tr_diario_0200` |
| Data Factory: actividades | `act_<tipo>_<objeto>` | `act_lookup_tablas` · `act_foreach_tablas` |
| Databricks (Unity Catalog) | catálogo `pede_dev`; esquemas por capa; tablas sin sufijo | `pede_dev.bronze.users` · `pede_dev.silver.transacciones` |
| Notebooks | `<nn>_<capa>_<acción>` | `01_bronze_cargar_csv` |

**Por qué `snake_case` dentro de Data Factory:** Azure no permite varios caracteres especiales en los nombres de datasets y otros objetos hijos (incluido el guion). Se usan guiones bajos para evitar errores.

## Etiquetas (tags) obligatorias
Las etiquetas no se heredan solas del grupo de recursos a sus recursos: hay que ponerlas en cada uno que se pueda.
| Etiqueta | Valor | Para qué |
|---|---|---|
| `curso` | `pede-azure-de` | Saber a qué pertenece el gasto |
| `alumno` | `margue` | Dueño |
| `entorno` | `dev` | Etapa |
| `modulo` | `m01` … `m05` | Cuándo se creó |
| `vence` | `2026-12-31` | Fecha de limpieza |

## Reglas de oro
1. **Sin datos personales ni confidenciales en nombres ni etiquetas** (lo indica la propia documentación de Microsoft).
2. **Todo en minúsculas** y sin tildes, ñ ni espacios.
3. **Un nombre global ocupado** se resuelve subiendo la instancia (`002`), nunca agregando letras al azar.
4. **No se renombra**: un grupo de recursos o una cuenta de almacenamiento no se pueden renombrar; hay que crear otro y borrar el viejo. Por eso se decide el nombre antes de crear.
5. **Un solo lugar de verdad:** el generador de `herramientas/generador-nombres.html` calcula y valida los nombres; no se escriben a mano.

## Fuentes
- Abreviaturas por tipo de recurso (Cloud Adoption Framework): https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
- Reglas y límites de nombres por proveedor de recursos: https://learn.microsoft.com/azure/azure-resource-manager/management/resource-name-rules
