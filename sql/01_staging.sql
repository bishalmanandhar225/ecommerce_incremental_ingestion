-- 01_staging.sql
-- Purpose: Create staging table to hold raw Kaggle Online Retail data

IF OBJECT_ID('dbo.stg_online_retail', 'U') IS NOT NULL
    DROP TABLE dbo.stg_online_retail;
GO

CREATE TABLE dbo.stg_online_retail (
    InvoiceNo   NVARCHAR(20)  NULL,
    StockCode   NVARCHAR(20)  NULL,
    Description NVARCHAR(255) NULL,
    Quantity    INT           NULL,
    InvoiceDate DATETIME      NULL,
    UnitPrice   DECIMAL(10,2) NULL,
    CustomerID  NVARCHAR(20)  NULL,
    Country     NVARCHAR(100) NULL,    updated_at  DATETIME2     NULL

);
GO