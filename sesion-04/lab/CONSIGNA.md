# Laboratorio S04 · Crear el lago ADLS Gen2 de Andina

**Duración:** 40 min · **Modalidad:** individual · **Entregable:** `evidencia-s04.md`
**Requisito:** acceso al portal de Azure y permiso para crear recursos en el grupo de S01/S02. Los CSV de Andina están en `material/s02/lab/datos/` (o en el kit de S02).

**Plan B sin suscripción:** usa la cuenta demo `stpededemobrs001` en modo lectura y completa la evidencia con capturas y la ACL observada; el instructor publica los resultados.

## Qué vas a demostrar

Al terminar vas a tener una cuenta ADLS Gen2 con zonas, datos crudos cargados y permisos verificados. No alcanza con crear la cuenta: hay que probar que el acceso funciona.

## Paso 1 · Crear la cuenta con HNS (8 min)

En el portal: **Storage accounts → Create**.

| Campo | Valor |
|---|---|
| Subscription | la del curso |
| Resource group | `rg-pede-<alumno>-dev-<región>-001` |
| Storage account name | `stpede<alumno>dev001` (3–24, solo minúsculas y números, único global) |
| Region | la misma del grupo |
| Performance | Standard |
| Redundancy | LRS |
| **Hierarchical namespace** | **Enabled** |
| Allow blob anonymous access | Disabled |
| Minimum TLS | 1.2 |

**Verificación:** Overview muestra **Hierarchical namespace: Enabled**.

## Paso 2 · Crear contenedores (5 min)

En **Data storage → Containers** crea:

- `bronze`
- `silver`
- `gold`

**Verificación:** los tres aparecen con **Anonymous access level: Private**.

## Paso 3 · Subir los CSV a bronce (10 min)

Sube los cinco CSV de Andina a:

```text
bronze/pedidos/fecha_carga=2026-10-10/
```

Esperado: `customers.csv`, `products.csv`, `orders.csv`, `order_items.csv`, `payments.csv`.

**Verificación:** los cinco archivos aparecen en `bronze/pedidos/fecha_carga=2026-10-10/`.

## Paso 4 · RBAC y ACL (10 min)

1. Crea un grupo `grp-analistas-datos` y agrega una segunda identidad de prueba.
2. En la cuenta, asigna al grupo el rol **Reader** (plano de control), no un rol de datos.
3. En `gold`, define una ACL `r-x` para `grp-analistas-datos`.
4. En `bronze`, no des ACL de lectura al grupo.
5. Prueba autenticando con Entra ID (**nunca con clave de cuenta**):
   - `gold` debe listar y leer;
   - `bronze` debe devolver 403 de autorización.

**Verificación:** la lectura de `bronze` falla con identidad de Entra ID y el código 403; `gold` funciona. Si usas clave de cuenta, la prueba no vale: la clave omite el ACL.

## Paso 5 · Ciclo de vida y evidencia (7 min)

- Deja anotada una política propuesta: hot → cool a los 90 días; delete a los 365 para logs temporales.
- Guarda la evidencia en `evidencia-s04.md`: capturas, rutas y resultado de la prueba de acceso.

## Errores frecuentes

| Error | Causa | Qué hacer |
|---|---|---|
| No puedo crear carpetas | La cuenta no tiene HNS | Recrear con hierarchical namespace |
| 403 al subir con CLI | Falta rol de datos | Asignar Storage Blob Data Contributor |
| El analista lee bronce | ACL muy amplio o default heredado | Revisar ACL y RBAC del contenedor |
| Archivo nuevo sin permiso | Falta default ACL | Definir default ACL en la raíz de la zona |
| Costo sube | Todo queda hot | Activar ciclo de vida |
