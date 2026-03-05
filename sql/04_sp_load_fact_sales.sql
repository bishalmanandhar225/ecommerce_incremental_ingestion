CREATE PROCEDURE dbo.sp_load_fact_sales
AS
BEGIN
SET NOCOUNT ON;
TRUNCATE TABLE dbo.fact_sales;
INSERT INTO dbo.fact_sales
(customer_key, product_key, InvoiceDate, Quantity, UnitPrice, updated_at)
SELECT
c.customer_key,
p.product_key,
s.InvoiceDate,
s.Quantity,
s.UnitPrice,
SYSUTCDATETIME() AS updated_at
FROM dbo.stg_online_retail s
JOIN dbo.dim_customer c
ON c.CustomerID = s.CustomerID
JOIN dbo.dim_product p
ON p.StockCode = s.StockCode;
END;