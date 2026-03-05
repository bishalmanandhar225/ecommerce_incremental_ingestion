CREATE OR ALTER PROCEDURE dbo.sp_load_dim_customer
AS
BEGIN
  SET NOCOUNT ON;

  TRUNCATE TABLE dbo.dim_customer;

  INSERT INTO dbo.dim_customer (CustomerID, Country, updated_at)
  SELECT
    s.CustomerID,
    MAX(s.Country) AS Country,
    SYSUTCDATETIME() AS updated_at
  FROM dbo.stg_online_retail s
  WHERE s.CustomerID IS NOT NULL
  GROUP BY s.CustomerID;
END;
GO