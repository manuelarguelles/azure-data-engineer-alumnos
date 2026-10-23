-- S06 · bronce -> plata
-- Grano: una fila por línea de pedido.
CREATE OR REPLACE TABLE pede.silver.pedidos_detalle
USING DELTA
LOCATION 'abfss://silver@stpededemobrs001.dfs.core.windows.net/delta/pedidos_detalle'
AS
SELECT
  o.order_id,
  o.order_date,
  o.channel                      AS canal,
  o.status                       AS estado,
  c.customer_id,
  c.full_name                    AS cliente,
  c.city                         AS ciudad,
  p.product_id,
  p.name                         AS producto,
  p.category                     AS categoria,
  oi.quantity                    AS cantidad,
  oi.unit_price                  AS precio_unitario,
  ROUND(oi.quantity * oi.unit_price, 2) AS importe_linea,
  pay.method                     AS metodo_pago,
  pay.paid_at                    AS pagado_en,
  pay.amount                     AS importe_pago,
  o._load_date
FROM pede.bronze.orders       o
JOIN pede.bronze.order_items  oi  ON o.order_id  = oi.order_id
JOIN pede.bronze.products     p   ON oi.product_id = p.product_id
JOIN pede.bronze.customers    c   ON o.customer_id = c.customer_id
LEFT JOIN pede.bronze.payments pay ON o.order_id = pay.order_id;
