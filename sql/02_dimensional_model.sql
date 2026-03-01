-- 02_dimensional_model.sql
-- Purpose: Build dimensions + fact table from staging (dimensional model)
-- Note: This keeps 1 row per CustomerID and 1 row per StockCode.

-- ---------- dim_customer ----------
IF OBJECT_ID('dbo.dim_customer', 'U') IS NOT NULL
    DROP TABLE dbo.dim_customer;
GO

CREATE TABLE dbo.dim_customer (
    customer_key INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID   NVARCHAR(20)  NOT NULL,
    Country      NVARCHAR(100) NULL,
    updated_at   DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

INSERT INTO dbo.dim_customer (CustomerID, Country)
SELECT
    s.CustomerID,
    MAX(s.Country) AS Country
FROM dbo.stg_online_retail s
WHERE s.CustomerID IS NOT NULL
GROUP BY s.CustomerID;
GO


-- ---------- dim_product ----------
IF OBJECT_ID('dbo.dim_product', 'U') IS NOT NULL
    DROP TABLE dbo.dim_product;
GO

CREATE TABLE dbo.dim_product (
    product_key  INT IDENTITY(1,1) PRIMARY KEY,
    StockCode    NVARCHAR(20)  NOT NULL,
    Description  NVARCHAR(255) NULL,
    UnitPrice    DECIMAL(10,2) NULL,
    updated_at   DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

INSERT INTO dbo.dim_product (StockCode, Description, UnitPrice)
SELECT
    s.StockCode,
    MAX(s.Description) AS Description,
    MAX(s.UnitPrice)   AS UnitPrice
FROM dbo.stg_online_retail s
WHERE s.StockCode IS NOT NULL
GROUP BY s.StockCode;
GO


-- ---------- fact_sales ----------
IF OBJECT_ID('dbo.fact_sales', 'U') IS NOT NULL
    DROP TABLE dbo.fact_sales;
GO

CREATE TABLE dbo.fact_sales (
    sales_key    BIGINT IDENTITY(1,1) PRIMARY KEY,
    customer_key INT            NOT NULL,
    product_key  INT            NOT NULL,
    InvoiceDate  DATETIME       NULL,
    Quantity     INT            NULL,
    UnitPrice    DECIMAL(10,2)  NULL,
    updated_at   DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_fact_sales_customer
        FOREIGN KEY (customer_key) REFERENCES dbo.dim_customer(customer_key),
    CONSTRAINT FK_fact_sales_product
        FOREIGN KEY (product_key) REFERENCES dbo.dim_product(product_key)
);
GO

INSERT INTO dbo.fact_sales (customer_key, product_key, InvoiceDate, Quantity, UnitPrice)
SELECT
    c.customer_key,
    p.product_key,
    s.InvoiceDate,
    s.Quantity,
    s.UnitPrice
FROM dbo.stg_online_retail s
JOIN dbo.dim_customer c
    ON c.CustomerID = s.CustomerID
JOIN dbo.dim_product p
    ON p.StockCode = s.StockCode;
GO