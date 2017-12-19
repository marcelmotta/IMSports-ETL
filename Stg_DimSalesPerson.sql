--SETUP TEMPORARY TABLES AND GET OLTP DATA
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempSalesPerson') IS NOT NULL
DROP TABLE [##tempSalesPerson]
CREATE TABLE [##tempSalesPerson] (
    [BusinessEntityID] int,
    [First-Name] nvarchar(50),
    [Last-Name] nvarchar(50),
    [HireDate] date,
    [Name] nvarchar(50),
    [MaritalStatus] nvarchar(1),
    [Gender] nvarchar(1)
)
INSERT INTO ##tempSalesPerson
SELECT
Sales.SalesPerson.BusinessEntityID,
People.PersonDetails.[First-Name],
People.PersonDetails.[Last-Name],
HR.Employee.HireDate,
Sales.SalesTerritory.Name,
HR.Employee.MaritalStatus,
HR.Employee.Gender

FROM Sales.SalesPerson
LEFT OUTER JOIN People.PersonDetails
ON Sales.SalesPerson.BusinessEntityID = People.PersonDetails.BusinessEntityID
LEFT OUTER JOIN Sales.SalesTerritory
ON Sales.SalesPerson.TerritoryID = Sales.SalesTerritory.TerritoryID
LEFT OUTER JOIN HR.Employee
ON HR.Employee.BusinessEntityID = Sales.SalesPerson.BusinessEntityID
;

--TRANSFORM DATA
USE IMSports_SalesSA;

SELECT
##tempSalesPerson.BusinessEntityID AS salBusinessID,
##tempSalesPerson.[First-Name] + ' ' + ##tempSalesPerson.[Last-Name] AS salName,
DATEDIFF (yy, ##tempSalesPerson.HireDate, GETDATE()) AS salYearsInCompany,
CASE
WHEN ##tempSalesPerson.Name IS NULL THEN 'Executive Sales'
ELSE ##tempSalesPerson.Name
END AS salTerritoryName,
CASE
WHEN ##tempSalesPerson.MaritalStatus = 'M' THEN 'Married'
WHEN ##tempSalesPerson.MaritalStatus = 'S' THEN 'Single'
END AS salMaritalStatus,
CASE
WHEN ##tempSalesPerson.Gender = 'M' THEN 'Male'
WHEN ##tempSalesPerson.Gender = 'F' THEN 'Female'
END AS salGender

FROM ##tempSalesPerson
;

--CREATE DUMMY RECORD FOR DIRECT SALES
IF (SELECT 
COUNT(Stg_DimSalesPerson.salBusinessID) 
FROM Stg_DimSalesPerson WHERE Stg_DimSalesPerson.salBusinessID = '9999') = 0
    BEGIN  
        INSERT INTO Stg_DimSalesPerson (salBusinessID, salName, salTerritoryName) 
		VALUES ('9999', '**Direct Purchase**','Online Store')  
    END  
;