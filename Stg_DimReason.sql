--GET DATA FROM OLTP ENVIRONMENT
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempReasonCodes') IS NOT NULL
DROP TABLE [##tempReasonCodes]
CREATE TABLE [##tempReasonCodes] (
    [SalesOrderID] int,
    [SalesReasonID] int
)
INSERT INTO ##tempReasonCodes
SELECT 
Sales.SalesOrderHeader_SalesReason.SalesOrderID,
Sales.SalesOrderHeader_SalesReason.SalesReasonID

FROM Sales.SalesOrderHeader_SalesReason
;

--TRANSFORM REASON CODES INTO REASON MATRIX
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempReasonMatrix') IS NOT NULL
DROP TABLE [##tempReasonMatrix]
CREATE TABLE [##tempReasonMatrix] (
    [SalesOrderID] int,
    [ReasonONE] int,
    [ReasonTWO] int,
    [ReasonTHREE] int,
    [ReasonFOUR] int,
    [ReasonFIVE] int,
    [ReasonSIX] int,
    [ReasonSEVEN] int,
    [ReasonEIGHT] int,
    [ReasonNINE] int,
    [ReasonTEN] int
)
INSERT INTO ##tempReasonMatrix
SELECT 
##tempReasonCodes.SalesOrderID,

SUM(
CASE 
WHEN ##tempReasonCodes.SalesReasonID = 1 
THEN 1
ELSE 0
END) AS ReasonONE,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 2
THEN 1
ELSE 0
END) AS ReasonTWO,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 3
THEN 1
ELSE 0
END) AS ReasonTHREE,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 4
THEN 1
ELSE 0
END) AS ReasonFOUR,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 5
THEN 1
ELSE 0
END) AS ReasonFIVE,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 6
THEN 1
ELSE 0
END) AS ReasonSIX,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 7
THEN 1
ELSE 0
END) AS ReasonSEVEN,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 8
THEN 1
ELSE 0
END) AS ReasonEIGHT,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 9
THEN 1
ELSE 0
END) AS ReasonNINE,

SUM(
CASE
WHEN ##tempReasonCodes.SalesReasonID = 10
THEN 1
ELSE 0
END) AS ReasonTEN

FROM ##tempReasonCodes
GROUP BY ##tempReasonCodes.SalesOrderID;

--GENERATE VALUES FOR BINARY TABLE
DECLARE @Binary TABLE (Digit bit)
INSERT @Binary
VALUES (0)
INSERT @Binary
VALUES (1)
SELECT ((a.Digit*512) + (b.Digit*256) + (c.Digit*128) + (d.Digit*64) +
(e.Digit*32) + (f.Digit*16) + (g.Digit*8) +
(h.Digit*4) + (i.Digit*2) + (j.Digit*1)) #,
a.Digit 'Price', b.Digit 'OnPromotion' , c.Digit 'MagazineAdvertisement',
d.Digit 'TelevisionAdvertisement', e.Digit 'Manufacturer', f.Digit 'Review',
g.Digit 'DemoEvent', h.Digit 'Sponsorship', i.Digit 'Quality', j.Digit 'Other'
FROM @Binary a
CROSS JOIN @Binary b
CROSS JOIN @Binary c
CROSS JOIN @Binary d
CROSS JOIN @Binary e
CROSS JOIN @Binary f
CROSS JOIN @Binary g
CROSS JOIN @Binary h
CROSS JOIN @Binary i
CROSS JOIN @Binary j
ORDER BY ((a.Digit*512) + (b.Digit*256) + (c.Digit*128) + (d.Digit*64) +
(e.Digit*32) + (f.Digit*16) + (g.Digit*8) +
(h.Digit*4) + (i.Digit*2) + (j.Digit*1))
;

--MATCH REASON MATRIX WITH BINARY TABLE
USE IMSports_SalesSA;

SELECT 
##tempReasonMatrix.SalesOrderID, 
Stg_DimReason.SK_ReasonID

FROM ##tempReasonMatrix, Stg_DimReason
WHERE ##tempReasonMatrix.reasonONE = Stg_DimReason.Price
AND ##tempReasonMatrix.reasonTWO = Stg_DimReason.OnPromotion
AND ##tempReasonMatrix.reasonTHREE = Stg_DimReason.MagazineAdvertisement
AND ##tempReasonMatrix.reasonFOUR = Stg_DimReason.TelevisionAdvertisement
AND ##tempReasonMatrix.reasonFIVE = Stg_DimReason.Manufacturer
AND ##tempReasonMatrix.reasonSIX = Stg_DimReason.Review
AND ##tempReasonMatrix.reasonSEVEN = Stg_DimReason.DemoEvent
AND ##tempReasonMatrix.reasonEIGHT = Stg_DimReason.Sponsorship
AND ##tempReasonMatrix.reasonNINE = Stg_DimReason.Quality
AND ##tempReasonMatrix.reasonTEN = Stg_DimReason.Other
ORDER BY ##tempReasonMatrix.SalesOrderID
;