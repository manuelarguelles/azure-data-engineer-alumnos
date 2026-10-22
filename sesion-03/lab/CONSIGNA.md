# Laboratorio S03 · Diseñar el lakehouse de Andina

**Duración:** 35 min · **Modalidad:** parejas · **Entregable:** `entrega-s03.md`
**Requisito:** haber visto S02 (5 tablas de Andina) y traer el mapa de fuentes.

## Qué vas a demostrar

Al terminar vas a tener una arquitectura de datos defendible: fuentes clasificadas, ventana de ingesta, zonas bronce/plata/oro, formato, partición y controles de gobierno. No se evalúa el dibujo: se evalúa la decisión y su justificación.

## Paso 1 · Inventario de fuentes (5 min)

Trabaja sobre las fuentes de Andina:

- SQL de pedidos y pagos
- CSV de productos, clientes y ventas
- JSON de clics y navegación
- PDFs de facturas y contratos
- Logs de aplicación
- Puntajes de modelos
- APIs externas (por ejemplo, tipo de cambio)
- Datos maestros de tiendas

Para cada fuente anota: formato, frecuencia, volumen aproximado, dueño y si tiene datos personales.

## Paso 2 · Ventana y formato (8 min)

Decide para cada fuente:

- ¿Batch o streaming? Justifica con la decisión de negocio, no con el servicio.
- ¿Formato de llegada y formato de guardado? CSV/JSON/Parquet/Delta.
- ¿Qué problema resuelve ese formato en la consulta?

## Paso 3 · Zonas bronce, plata y oro (10 min)

Para cada zona define:

| Zona | Qué guarda | Qué NO guarda | Dueño | Prueba de calidad |
|---|---|---|---|---|
| Bronce | | | | |
| Plata | | | | |
| Oro | | | | |

Cada zona debe responder una pregunta distinta. Si dos zonas tienen la misma tabla, justifica por qué.

## Paso 4 · Particiones y gobierno (7 min)

- Elige la partición principal de la zona que más se consulta y explica por qué.
- Marca dónde van identidad, RBAC/ACL, cifrado, catálogo, linaje y control de costo.
- Identifica al menos un dato con PII y una medida para minimizarlo o restringirlo.

## Paso 5 · Dibujo y riesgo (5 min)

Dibuja el flujo de punta a punta (puede ser a mano o en la plantilla) y agrega:

- Una pregunta abierta que todavía no puedes responder.
- Un Plan B si una fuente no está disponible o llega tarde.

## Entregable `entrega-s03.md`

Completa `plantilla-diseno.md` con:

1. Inventario clasificado.
2. Decisión batch/streaming por fuente.
3. Zonas bronce/plata/oro con dueño y calidad.
4. Partición y controles de gobierno.
5. Pregunta abierta y Plan B.

## Evaluación

| Criterio | Puntos |
|---|---|
| Fuentes clasificadas con formato y frecuencia | 2 |
| Ventana batch/streaming justificada | 2 |
| Zonas con una pregunta por zona | 2 |
| Formato y partición coherentes con la consulta | 1 |
| Gobierno (PII, acceso, linaje, costo) | 2 |
| Riesgo y Plan B | 1 |

**No aprobado:** lista de servicios sin justificación, o una sola zona para todo sin explicar el supuesto.
