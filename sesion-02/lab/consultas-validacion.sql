SELECT 'customers' AS tabla, COUNT(*) AS filas FROM dbo.customers
UNION ALL SELECT 'products', COUNT(*) FROM dbo.products
UNION ALL SELECT 'orders', COUNT(*) FROM dbo.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM dbo.order_items
UNION ALL SELECT 'payments', COUNT(*) FROM dbo.payments;

SELECT SUM(oi.quantity * oi.unit_price) AS total_pagado
FROM dbo.orders o
JOIN dbo.order_items oi ON oi.order_id = o.order_id
JOIN dbo.payments p     ON p.order_id = o.order_id
WHERE o.status = 'pagado';

SELECT c.full_name, p.method,
       SUM(oi.quantity * oi.unit_price) AS total
FROM dbo.customers c
JOIN dbo.orders o       ON o.customer_id = c.customer_id
JOIN dbo.order_items oi ON oi.order_id = o.order_id
JOIN dbo.payments p     ON p.order_id = o.order_id
WHERE o.status = 'pagado'
GROUP BY c.full_name, p.method
ORDER BY c.full_name, p.method;

SELECT o.order_id, p.amount AS pagado,
       SUM(oi.quantity * oi.unit_price) AS calculado,
       p.amount - SUM(oi.quantity * oi.unit_price) AS diferencia
FROM dbo.orders o
JOIN dbo.order_items oi ON oi.order_id = o.order_id
JOIN dbo.payments p     ON p.order_id = o.order_id
GROUP BY o.order_id, p.amount
HAVING p.amount <> SUM(oi.quantity * oi.unit_price);
