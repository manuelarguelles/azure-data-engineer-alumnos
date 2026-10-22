SET NOCOUNT ON;

IF OBJECT_ID('dbo.payments', 'U') IS NOT NULL DROP TABLE dbo.payments;
IF OBJECT_ID('dbo.order_items', 'U') IS NOT NULL DROP TABLE dbo.order_items;
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL DROP TABLE dbo.orders;
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL DROP TABLE dbo.products;
IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL DROP TABLE dbo.customers;

CREATE TABLE dbo.customers (
    customer_id  INT           NOT NULL,
    full_name    NVARCHAR(120) NOT NULL,
    email        NVARCHAR(160) NOT NULL,
    city         NVARCHAR(80)  NOT NULL,
    signup_date  DATE          NOT NULL,
    CONSTRAINT PK_customers PRIMARY KEY (customer_id),
    CONSTRAINT UQ_customers_email UNIQUE (email)
);

CREATE TABLE dbo.products (
    product_id  INT           NOT NULL,
    name        NVARCHAR(120) NOT NULL,
    category    NVARCHAR(60)  NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,
    active      BIT           NOT NULL CONSTRAINT DF_products_active DEFAULT (1),
    CONSTRAINT PK_products PRIMARY KEY (product_id),
    CONSTRAINT CK_products_precio CHECK (unit_price >= 0)
);

CREATE TABLE dbo.orders (
    order_id     INT          NOT NULL,
    customer_id  INT          NOT NULL,
    order_date   DATE         NOT NULL,
    channel      NVARCHAR(20) NOT NULL,
    status       NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_orders PRIMARY KEY (order_id),
    CONSTRAINT FK_orders_customers FOREIGN KEY (customer_id) REFERENCES dbo.customers (customer_id),
    CONSTRAINT CK_orders_canal CHECK (channel IN ('web', 'tienda')),
    CONSTRAINT CK_orders_estado CHECK (status IN ('pagado', 'pendiente', 'cancelado'))
);

CREATE TABLE dbo.order_items (
    order_id    INT           NOT NULL,
    product_id  INT           NOT NULL,
    quantity    INT           NOT NULL,
    unit_price  DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_order_items_orders FOREIGN KEY (order_id) REFERENCES dbo.orders (order_id),
    CONSTRAINT FK_order_items_products FOREIGN KEY (product_id) REFERENCES dbo.products (product_id),
    CONSTRAINT CK_order_items_cantidad CHECK (quantity > 0),
    CONSTRAINT CK_order_items_precio CHECK (unit_price >= 0)
);

CREATE TABLE dbo.payments (
    payment_id  INT           NOT NULL,
    order_id    INT           NOT NULL,
    paid_at     DATETIME2(0)  NOT NULL,
    method      NVARCHAR(30)  NOT NULL,
    amount      DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_payments PRIMARY KEY (payment_id),
    CONSTRAINT UQ_payments_order UNIQUE (order_id),
    CONSTRAINT FK_payments_orders FOREIGN KEY (order_id) REFERENCES dbo.orders (order_id),
    CONSTRAINT CK_payments_monto CHECK (amount >= 0)
);
