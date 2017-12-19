--WIPE DATA FROM STAGING AREA AFTER ETL
USE IMSports_SalesSA;
TRUNCATE TABLE Stg_FactSalesDetails;
TRUNCATE TABLE Stg_FactSalesHeader;

DELETE FROM Stg_DimCustomer;
DELETE FROM Stg_DimLocation;
DELETE FROM Stg_DimProduct;
DELETE FROM Stg_DimReason;
DELETE FROM Stg_DimSalesPerson;
DELETE FROM Stg_DimTime;

TRUNCATE TABLE csvReason;
TRUNCATE TABLE tempReasonSummary;

--RESET IDENTITY COUNT
DBCC CHECKIDENT ('[Stg_DimCustomer]', RESEED, 0);
DBCC CHECKIDENT ('[Stg_DimLocation]', RESEED, 0);
DBCC CHECKIDENT ('[Stg_DimProduct]', RESEED, 0);
DBCC CHECKIDENT ('[Stg_DimReason]', RESEED, 0);
DBCC CHECKIDENT ('[Stg_DimSalesPerson]', RESEED, 0);