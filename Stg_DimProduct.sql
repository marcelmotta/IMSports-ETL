--SETUP TEMPORARY TABLE AND GET OLTP DATA
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempProduct') IS NOT NULL
DROP TABLE [##tempProduct]
CREATE TABLE [##tempProduct] (
    [proBusinessID] int,
    [proName] nvarchar(50),
    [proColor] nvarchar(50),
    [proDescription] nvarchar(50),
    [proCategoryID] int
)
INSERT INTO ##tempProduct
SELECT
Manufacture.Product.ProductID AS proBusinessID,
Manufacture.Product.Name AS proName,
Manufacture.Product.Color AS proColor,
Manufacture.ProductSubtype.Name AS proDescription,
Manufacture.ProductSubtype.ProductCategoryID AS proCategoryID

FROM Manufacture.Product
LEFT JOIN Manufacture.ProductSubtype
ON Manufacture.Product.ProductSubcategoryID = Manufacture.ProductSubtype.ProductSubcategoryID
;

--TRANSFORM DATA
USE IMSports_SalesSA;

SELECT
##tempProduct.proBusinessID,
##tempProduct.proName,
##tempProduct.proColor,
##tempProduct.proDescription,
CASE
WHEN ##tempProduct.proCategoryID = 1 THEN 'Manufactured bike'
WHEN ##tempProduct.proCategoryID = 2 THEN 'Manufactured component'
WHEN ##tempProduct.proCategoryID = 3 THEN 'Apparel'
WHEN ##tempProduct.proCategoryID = 4 THEN 'Accessories'
ELSE 'Component'
END AS proCategory

FROM ##tempProduct
;
