# Laboratorio S06 · Consolidar bronce en plata

**Duración:** 40 min · **Modalidad:** individual · **Entregable:** `evidencia-s06.md`
**Requisito:** las cinco tablas de `pede.bronze` creadas en S05 y un SQL warehouse disponible.

## Qué vas a demostrar

Al terminar vas a tener `pede.silver.pedidos_detalle` con grano por línea de pedido, controles de calidad en cero, tres respuestas de negocio y un job programado en modo pausado con su historial.

## Paso 1 · Verifica el bronce (3 min)

```sql
SELECT 'customers' AS tabla, COUNT(*) AS filas FROM pede.bronze.customers
UNION ALL SELECT 'products',    COUNT(*) FROM pede.bronze.products
UNION ALL SELECT 'orders',      COUNT(*) FROM pede.bronze.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM pede.bronze.order_items
UNION ALL SELECT 'payments',    COUNT(*) FROM pede.bronze.payments
ORDER BY tabla;
```

**Esperado:** 5, 8, 10, 15 y 9.

## Paso 2 · Crea la tabla plata (12 min)

Copia `lab/02_silver.sql` en un archivo SQL del workspace y ejecútalo, o pega la consulta en el SQL Editor.

| Decisión | Valor |
|---|---|
| Grano | Una fila por línea de pedido |
| Join de pagos | `LEFT` para conservar el pedido cancelado |
| Destino | `abfss://silver@<tu-storage>.dfs.core.windows.net/delta/pedidos_detalle` |

**Verificación:** `SELECT COUNT(*)` devuelve **15** filas y 10 pedidos distintos.

## Paso 3 · Controles de calidad (8 min)

```sql
-- Claves nulas: debe dar 0
SELECT COUNT(*) AS nulos
FROM pede.silver.pedidos_detalle
WHERE order_id IS NULL OR product_id IS NULL;

-- Duplicados por grano: debe dar 0
SELECT COUNT(*) AS duplicados
FROM (
  SELECT order_id, product_id, COUNT(*) AS n
  FROM pede.silver.pedidos_detalle
  GROUP BY order_id, product_id
  HAVING n > 1
);

-- Totales contra bronce: ambos 13407.50
SELECT
  (SELECT ROUND(SUM(importe_linea),2) FROM pede.silver.pedidos_detalle) AS plata,
  (SELECT ROUND(SUM(quantity*unit_price),2) FROM pede.bronze.order_items) AS bronce;
```

**Esperado:** 0, 0 y `13407.50` en ambas columnas.

## Paso 4 · Responde tres preguntas (7 min)

```sql
-- Por canal y estado
SELECT canal, estado, COUNT(DISTINCT order_id) AS pedidos,
       ROUND(SUM(importe_linea),2) AS ingresos
FROM pede.silver.pedidos_detalle
GROUP BY canal, estado ORDER BY canal;

-- Por categoría
SELECT categoria, ROUND(SUM(importe_linea),2) AS ingresos
FROM pede.silver.pedidos_detalle
GROUP BY categoria ORDER BY ingresos DESC;

-- Total pagado
SELECT ROUND(SUM(amount),2) AS total_pagado FROM pede.bronze.payments;
```

**Esperado:** web pagado 10.404,50 (6) · tienda pagado 2.754,00 (3) · web cancelado 249,00 (1); Tecnología 11.495,00 y Accesorios 1.912,50; total pagado 13.158,50.

**Explica:** ¿por qué el total pagado no coincide con los ingresos por líneas?

## Paso 5 · Programa el job (7 min)

**Jobs & Pipelines → Create job.**

| Campo | Valor |
|---|---|
| Nombre | `job-pede-s06-plata` |
| Tarea | SQL |
| Warehouse | el SQL warehouse del curso |
| Archivo SQL | el del Paso 2 |
| Schedule | diario 03:00, `America/Lima`, **pausado** |

Ejecuta una vez con **Run now**. La tarea debe terminar en `Succeeded`.

**Verificación:** el run muestra estado, duración y el SQL ejecutado.

## Paso 6 · Linaje (3 min)

**Catalog → pede → silver → pedidos_detalle → Lineage.**

**Verificación:** las cinco tablas bronce y el job aparecen como upstream.

## Evidencia (`evidencia-s06.md`)

1. Salida del conteo de plata (15 filas, 10 pedidos).
2. Los tres controles: 0, 0, `13407.50` / `13407.50`.
3. Tabla de resultados por canal y estado.
4. Captura del job en `Succeeded` con duración.
5. Captura del linaje.
6. Una frase explicando la diferencia de 249,00.

## Errores frecuentes

| Error | Causa | Qué hacer |
|---|---|---|
| 16 filas o más | Join duplicado por pagos | Revisar que haya un pago por pedido |
| 14 filas o menos | `INNER JOIN` con una tabla incompleta | Usar `LEFT` y revisar huérfanos |
| Total pagado inflado | Se sumó `importe_pago` por línea | Sumar pagos desde `payments` |
| La tabla no se actualiza | El job apunta a otro archivo o ruta | Revisar path y `LOCATION` |
| Linaje vacío | Lectura por ruta con clave | Leer tablas de Unity Catalog |
