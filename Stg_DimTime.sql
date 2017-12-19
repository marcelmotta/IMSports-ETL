--SETUP TEMPORARY TABLE AND GET OLTP DATA
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempTime') IS NOT NULL
DROP TABLE [##tempTime]
CREATE TABLE [##tempTime] (
    [SalesOrderID] int,
    [OrderDate] datetime
)
INSERT INTO ##tempTime
SELECT
Sales.SalesOrderHeader.SalesOrderID,
Sales.SalesOrderHeader.OrderDate

FROM Sales.SalesOrderHeader
;

--TRANSFORM DATA
USE IMSports_SalesSA;

SELECT DISTINCT
CONVERT(nvarchar(50), ##tempTime.OrderDate, 112) AS SK_TimeID,
YEAR(##tempTime.OrderDate) AS timYear,
MONTH(##tempTime.OrderDate) AS timMonth,
DAY(##tempTime.OrderDate) AS timDay,
DATEPART(QUARTER, ##tempTime.OrderDate) AS timQuarter,
CASE
WHEN DATEPART(QUARTER, ##tempTime.OrderDate) = 1 THEN 'Winter'
WHEN DATEPART(QUARTER, ##tempTime.OrderDate) = 2 THEN 'Spring'
WHEN DATEPART(QUARTER, ##tempTime.OrderDate) = 3 THEN 'Summer'
WHEN DATEPART(QUARTER, ##tempTime.OrderDate) = 4 THEN 'Fall'
END AS timSeason,
DATEPART(WEEKDAY, ##tempTime.OrderDate) AS timWeekday,
CASE
WHEN DATEPART(WEEKDAY, ##tempTime.OrderDate) = 1 THEN 'Monday'
WHEN DATEPART(WEEKDAY, ##tempTime.OrderDate) = 2 THEN 'Tuesday'
WHEN DATEPART(WEEKDAY, ##tempTime.OrderDate) = 3 THEN 'Wednesday'
WHEN DATEPART(WEEKDAY, ##tempTime.OrderDate) = 4 THEN 'Thursday'
WHEN DATEPART(WEEKDAY, ##tempTime.OrderDate) = 5 THEN 'Friday'
WHEN DATEPART(WEEKDAY, ##tempTime.OrderDate) = 6 THEN 'Saturday'
WHEN DATEPART(WEEKDAY, ##tempTime.OrderDate) = 7 THEN 'Sunday'
END AS timDayOfWeek

FROM ##tempTime
ORDER BY timYear, timMonth, timDay
;