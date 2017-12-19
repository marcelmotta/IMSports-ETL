--SETUP TEMPORARY TABLE AND GET OLTP DATA
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempFactSalesDetails') IS NOT NULL
DROP TABLE [##tempFactSalesDetails]
CREATE TABLE [##tempFactSalesDetails] (
    [SalesOrderID] int,
	[CustomerID] int,
	[ShipToAddressID] int,
	[ProductID] int,
	[SalesPersonID] int,
	[OrderDate] datetime,
    [OrderQty] int,
    [UnitPrice] money,
    [UnitPriceDiscount] numeric(10,2),
    [LineTotal] money
)
INSERT INTO ##tempFactSalesDetails
SELECT
Sales.SalesOrderDetail.SalesOrderID,
Sales.SalesOrderHeader.CustomerID,
Sales.SalesOrderHeader.ShipToAddressID,
Sales.SalesOrderDetail.ProductID,
Sales.SalesOrderHeader.SalesPersonID,
Sales.SalesOrderHeader.OrderDate,
Sales.SalesOrderDetail.OrderQty,
Sales.SalesOrderDetail.UnitPrice,
Sales.SalesOrderDetail.UnitPriceDiscount,
Sales.SalesOrderDetail.LineTotal

FROM Sales.SalesOrderDetail
LEFT JOIN Sales.SalesOrderHeader
ON Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
;

--LOAD DATA INTO FACTSALESDETAILS
USE IMSports_SalesSA;

SELECT
Stg_DimCustomer.SK_CustomerID,
Stg_DimLocation.SK_LocationID,
Stg_DimProduct.SK_ProductID,
ISNULL(tempReasonSummary.ReasonID,1) AS SK_ReasonID,
ISNULL(Stg_DimSalesPerson.SK_SalesPersonID,1) AS SK_SalesPersonID,
Stg_DimTime.SK_TimeID,
SUM(##tempFactSalesDetails.OrderQty) AS TotalItems,
AVG(##tempFactSalesDetails.UnitPrice) AS AverageUnitPrice,
AVG(##tempFactSalesDetails.UnitPriceDiscount) AS AverageDiscount,
SUM(##tempFactSalesDetails.LineTotal) AS Total

FROM ##tempFactSalesDetails
LEFT JOIN Stg_DimCustomer
ON ##tempFactSalesDetails.CustomerID = Stg_DimCustomer.cusBusinessID
LEFT JOIN Stg_DimLocation
ON ##tempFactSalesDetails.ShipToAddressID = Stg_DimLocation.locBusinessID
LEFT JOIN Stg_DimProduct
ON ##tempFactSalesDetails.ProductID = Stg_DimProduct.proBusinessID
LEFT JOIN Stg_DimSalesPerson
ON ##tempFactSalesDetails.SalesPersonID = Stg_DimSalesPerson.salBusinessID
LEFT JOIN tempReasonSummary
ON ##tempFactSalesDetails.SalesOrderID = tempReasonSummary.SalesOrderID
LEFT JOIN Stg_DimTime
ON CONVERT(nvarchar(50), ##tempFactSalesDetails.OrderDate, 112) = Stg_DimTime.SK_TimeID
GROUP BY 
##tempFactSalesDetails.SalesOrderID,
Stg_DimCustomer.SK_CustomerID,
Stg_DimLocation.SK_LocationID,
Stg_DimProduct.SK_ProductID,
tempReasonSummary.ReasonID,
Stg_DimSalesPerson.SK_SalesPersonID,
Stg_DimTime.SK_TimeID
ORDER BY Stg_DimTime.SK_TimeID ASC
;
