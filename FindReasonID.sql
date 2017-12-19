USE IMSports_SalesSA

DECLARE @sql as nvarchar(max)
DECLARE @tablename as nvarchar(50)
DECLARE @col1 as nvarchar(50)
DECLARE @col2 as nvarchar(50)
DECLARE @col3 as nvarchar(50)
DECLARE @col4 as nvarchar(50)
DECLARE @col5 as nvarchar(50)
DECLARE @col6 as nvarchar(50)
DECLARE @col7 as nvarchar(50)
DECLARE @col8 as nvarchar(50)
DECLARE @col9 as nvarchar(50)
DECLARE @col10 as nvarchar(50)

SET @col1 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 1)
SET @col2 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 2)
SET @col3 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 3)
SET @col4 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 4)
SET @col5 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 5)
SET @col6 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 6)
SET @col7 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 7)
SET @col8 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 8)
SET @col9 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 9)
SET @col10 = (SELECT DISTINCT csvReason.ReasonName FROM csvReason WHERE csvReason.SalesReasonID = 10)

SET @tablename = 'testreason';

SET @sql = '
CREATE TABLE '+@tablename+' (
	SalesOrderID,
	'+@col1+' int,
	'+@col2+' int,
	'+@col3+' int,
	'+@col4+' int,
	'+@col5+' int,
	'+@col6+' int,
	'+@col7+' int,
	'+@col8+' int,
	'+@col9+' int,
	'+@col10+' int
	)'

EXEC (@sql)