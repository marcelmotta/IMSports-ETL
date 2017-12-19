--SETUP TEMPORARY TABLE AND GET OLTP DATA
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempFactSalesHeader') IS NOT NULL
DROP TABLE [##tempFactSalesHeader]
CREATE TABLE [##tempFactSalesHeader] (
    [SalesOrderID] int,
	[CustomerID] int,
	[ShipToAddressID] int,
	[SalesPersonID] int,
	[OrderDate] datetime,
    [SubTotal] money
)
INSERT INTO ##tempFactSalesHeader
SELECT
Sales.SalesOrderHeader.SalesOrderID,
Sales.SalesOrderHeader.CustomerID,
Sales.SalesOrderHeader.ShipToAddressID,
Sales.SalesOrderHeader.SalesPersonID,
Sales.SalesOrderHeader.OrderDate,
Sales.SalesOrderHeader.SubTotal

FROM Sales.SalesOrderHeader

--LOAD DATA INTO FACTSALESHEADER
USE IMSports_SalesSA;

SELECT
Stg_DimCustomer.SK_CustomerID,
Stg_DimLocation.SK_LocationID,
ISNULL(tempReasonSummary.ReasonID,1) AS SK_ReasonID,
ISNULL(Stg_DimSalesPerson.SK_SalesPersonID,1) AS SK_SalesPersonID,
Stg_DimTime.SK_TimeID,
SUM(##tempFactSalesHeader.SubTotal) AS SubTotal

FROM ##tempFactSalesHeader
LEFT JOIN Stg_DimCustomer
ON ##tempFactSalesHeader.CustomerID = Stg_DimCustomer.cusBusinessID
LEFT JOIN Stg_DimLocation
ON ##tempFactSalesHeader.ShipToAddressID = Stg_DimLocation.locBusinessID
LEFT JOIN Stg_DimSalesPerson
ON ##tempFactSalesHeader.SalesPersonID = Stg_DimSalesPerson.salBusinessID
LEFT JOIN tempReasonSummary
ON ##tempFactSalesHeader.SalesOrderID = tempReasonSummary.SalesOrderID
LEFT JOIN Stg_DimTime
ON CONVERT(nvarchar(50), ##tempFactSalesHeader.OrderDate, 112) = Stg_DimTime.SK_TimeID
GROUP BY
Stg_DimCustomer.SK_CustomerID,
Stg_DimLocation.SK_LocationID,
tempReasonSummary.ReasonID,
Stg_DimSalesPerson.SK_SalesPersonID,
Stg_DimTime.SK_TimeID
ORDER BY Stg_DimTime.SK_TimeID ASC
;