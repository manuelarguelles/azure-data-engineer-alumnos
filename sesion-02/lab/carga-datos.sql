SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;

INSERT INTO dbo.customers (customer_id, full_name, email, city, signup_date) VALUES
    (1, N'Ana Torres',     N'ana.torres@example.com',     N'Lima',     '2026-09-15'),
    (2, N'Luis Ramírez',   N'luis.ramirez@example.com',   N'Arequipa', '2026-09-18'),
    (3, N'Carla Mendoza',  N'carla.mendoza@example.com',  N'Trujillo', '2026-09-22'),
    (4, N'Diego Salazar',  N'diego.salazar@example.com',  N'Cusco',    '2026-10-01'),
    (5, N'María Paredes',  N'maria.paredes@example.com',  N'Lima',     '2026-10-05');

INSERT INTO dbo.products (product_id, name, category, unit_price, active) VALUES
    (101, N'Laptop 14 Pro',      N'Tecnología', 3499.00, 1),
    (102, N'Mouse inalámbrico',  N'Accesorios',   89.90, 1),
    (103, N'Teclado mecánico',   N'Accesorios',  249.00, 1),
    (104, N'Monitor 27 4K',      N'Tecnología', 1299.00, 1),
    (105, N'Mochila urbana',     N'Accesorios',  159.90, 1),
    (106, N'Tablet 11',          N'Tecnología', 1899.00, 0),
    (107, N'Hub USB-C',          N'Accesorios',  129.00, 1),
    (108, N'Webcam Full HD',     N'Accesorios',  219.00, 1);

INSERT INTO dbo.orders (order_id, customer_id, order_date, channel, status) VALUES
    (1001, 1, '2026-10-10', N'web',    N'pagado'),
    (1002, 2, '2026-10-11', N'tienda', N'pagado'),
    (1003, 1, '2026-10-12', N'web',    N'pagado'),
    (1004, 3, '2026-10-13', N'web',    N'pagado'),
    (1005, 4, '2026-10-14', N'tienda', N'pagado'),
    (1006, 5, '2026-10-15', N'web',    N'pagado'),
    (1007, 2, '2026-10-16', N'web',    N'cancelado'),
    (1008, 3, '2026-10-17', N'tienda', N'pagado'),
    (1009, 4, '2026-10-18', N'web',    N'pagado'),
    (1010, 5, '2026-10-19', N'web',    N'pagado');

INSERT INTO dbo.order_items (order_id, product_id, quantity, unit_price) VALUES
    (1001, 101, 1, 3499.00),
    (1001, 102, 2,   89.90),
    (1002, 103, 1,  249.00),
    (1002, 107, 1,  129.00),
    (1003, 104, 1, 1299.00),
    (1004, 105, 1,  159.90),
    (1004, 108, 1,  219.00),
    (1005, 106, 1, 1899.00),
    (1006, 101, 1, 3499.00),
    (1006, 102, 1,   89.90),
    (1007, 103, 1,  249.00),
    (1008, 107, 2,  129.00),
    (1008, 108, 1,  219.00),
    (1009, 104, 1, 1299.00),
    (1010, 105, 1,  159.90);

INSERT INTO dbo.payments (payment_id, order_id, paid_at, method, amount) VALUES
    (1, 1001, '2026-10-10 10:15:00', N'tarjeta',       3678.80),
    (2, 1002, '2026-10-11 16:40:00', N'yape',           378.00),
    (3, 1003, '2026-10-12 09:05:00', N'tarjeta',       1299.00),
    (4, 1004, '2026-10-13 18:20:00', N'transferencia',  378.90),
    (5, 1005, '2026-10-14 12:10:00', N'efectivo',       1899.00),
    (6, 1006, '2026-10-15 20:30:00', N'tarjeta',       3588.90),
    (7, 1008, '2026-10-17 11:45:00', N'yape',           477.00),
    (8, 1009, '2026-10-18 14:25:00', N'transferencia', 1299.00),
    (9, 1010, '2026-10-19 17:55:00', N'transferencia', 159.90);

COMMIT TRANSACTION;
