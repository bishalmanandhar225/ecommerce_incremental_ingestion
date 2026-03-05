CREATE OR ALTER PROCEDURE dbo.sp_load_dim_product
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.dim_product;

    INSERT INTO dbo.dim_product (StockCode, Description, UnitPrice, updated_at)
    SELECT
        s.StockCode,
        MAX(s.Description) AS Description,
        MAX(s.UnitPrice)   AS UnitPrice,
        SYSUTCDATETIME()   AS updated_at
    FROM dbo.stg_online_retail s
    WHERE s.StockCode IS NOT NULL
    GROUP BY s.StockCode;
END;
GO