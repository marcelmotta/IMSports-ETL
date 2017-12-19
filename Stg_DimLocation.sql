--SETUP TEMPORARY TABLE AND GET OLTP DATA
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempLocation') IS NOT NULL
DROP TABLE [##tempLocation]
CREATE TABLE [##tempLocation] (
    [locBusinessID] int,
    [locCountryCode] nvarchar(3),
    [locCityName] nvarchar(50),
    [locPostalCode] nvarchar(50),
    [locStateName] nvarchar(50),
    [locSalesTerritoryName] nvarchar(50),
    [locSalesTerritoryGroup] nvarchar(50)
)
INSERT INTO ##tempLocation
SELECT 
People.Address.AddressID AS locBusinessID,
People.State.CountryRegionCode AS locCountryCode,
People.Address.City AS locCityName,
People.Address.[Postal-Code] AS locPostalCode,
People.State.Name AS locStateName,
Sales.SalesTerritory.Name AS locSalesTerritoryName,
Sales.SalesTerritory.[Group] AS locSalesTerritoryGroup

FROM People.Address
INNER JOIN People.State
ON People.State.StateProvinceID = People.Address.StateProvinceID
INNER JOIN Sales.SalesTerritory
ON People.State.TerritoryID = Sales.SalesTerritory.TerritoryID
;

--TRANSFORM DATA
USE IMSports_SalesSA;

SELECT DISTINCT
##tempLocation.locBusinessID,
##tempLocation.locCountryCode,
##tempLocation.locCityName,
##tempLocation.locPostalCode,
##tempLocation.locStateName,
##tempLocation.locSalesTerritoryName,
##tempLocation.locSalesTerritoryGroup

FROM ##tempLocation
;
