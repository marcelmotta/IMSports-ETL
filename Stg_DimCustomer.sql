--SETUP TEMP TABLE AND GET OLTP DATA
USE IMSports;

IF OBJECT_ID('tempdb.dbo.##tempCustomer') IS NOT NULL
DROP TABLE [##tempCustomer]
CREATE TABLE [##tempCustomer] (
    [CustomerID] int,
    [PersonID] int,
    [DemographicInfo] xml,
    [StoreID] int,
    [Demographics] xml
)
INSERT INTO ##tempCustomer
SELECT 
Sales.Client.CustomerID, 
Sales.Client.PersonID,
People.PersonDetails.DemographicInfo,
Sales.Client.StoreID,
Sales.Store.Demographics

FROM Sales.Client
LEFT JOIN People.PersonDetails
ON People.PersonDetails.BusinessEntityID = Sales.Client.PersonID
LEFT JOIN Sales.Store
ON Sales.Store.BusinessEntityID = Sales.Client.StoreID
;

--TRANSFORM DATA
USE IMSports_SalesSA;

WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey' AS pvtSurvey, 
					'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey' AS comSurvey)

SELECT tempCustomer.CustomerID AS cusBusinessID, 
CASE
WHEN tempCustomer.PersonID IS NOT NULL AND tempCustomer.StoreID IS NOT NULL THEN 'Private/Commercial'
WHEN tempCustomer.PersonID IS NOT NULL AND tempCustomer.StoreID IS NULL THEN 'Private'
WHEN tempCustomer.PersonID IS NULL AND tempCustomer.StoreID IS NOT NULL THEN 'Commercial'
END AS cusCategory,

DATEDIFF(yy,P.value('pvtSurvey:BirthDate[1]','varchar(50)'),GETDATE()) AS cusAge,
P.value('pvtSurvey:MaritalStatus[1]','varchar(50)') AS cusMaritalStatus,
P.value('pvtSurvey:YearlyIncome[1]','varchar(50)') AS cusYearlyIncome,
P.value('pvtSurvey:Gender[1]','varchar(50)') AS cusGender,
P.value('pvtSurvey:TotalChildren[1]','varchar(50)') AS cusNumberOfChildren,
P.value('pvtSurvey:NumberChildrenAtHome[1]','varchar(50)') AS cusNumberOfChildrenAtHome,
P.value('pvtSurvey:Education[1]','varchar(50)') AS cusEducation,
P.value('pvtSurvey:Occupation[1]','varchar(50)') AS cusOccupation,
P.value('pvtSurvey:HomeOwnerFlag[1]','varchar(50)') AS cusHomeOwnerFlag,
P.value('pvtSurvey:NumberCarsOwned[1]','varchar(50)') AS cusNumberOfCarsOwned,
P.value('pvtSurvey:CommuteDistance[1]','varchar(50)') AS cusCommuteDistance,

C.value('comSurvey:AnnualSales[1]','int') AS cusAnnualSales,
C.value('comSurvey:AnnualRevenue[1]','int') AS cusAnnualRevenue,
C.value('comSurvey:BusinessType[1]','varchar(50)') AS cusBusinessType,
DATEDIFF(yy,C.value('comSurvey:YearOpened[1]','varchar(50)'),GETDATE()) AS cusYearsOfOperation,
C.value('comSurvey:Specialty[1]','varchar(50)') AS cusSpecialty,
C.value('comSurvey:SquareFeet[1]','int') AS cusSquareFeet,
C.value('comSurvey:Brands[1]','varchar(50)') AS cusBrands,
C.value('comSurvey:Internet[1]','varchar(50)') AS cusInternetConnection,
C.value('comSurvey:NumberEmployees[1]','int') AS cusNumberOfEmployees

FROM tempCustomer
OUTER APPLY DemographicInfo.nodes('/pvtSurvey:IndividualSurvey') AS pvt(P)
OUTER APPLY Demographics.nodes('/comSurvey:StoreSurvey') AS com(C)
ORDER BY tempCustomer.CustomerID
;


/*
-- XML shredding by using value() method
SELECT
BusinessEntityID,
[First-Name],
[Last-Name],
DemographicInfo.value('declare namespace survey1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; (/survey1:IndividualSurvey/survey1:MaritalStatus)[1]','varchar(50)') AS MaritalStatus,
DemographicInfo.value('declare namespace survey2="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; (/survey2:IndividualSurvey/survey2:YearlyIncome)[1]','varchar(50)') AS YearlyIncome,
DemographicInfo.value('declare namespace survey3="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; (/survey3:IndividualSurvey/survey3:BirthDate)[1]','varchar(50)') AS BirthDate,
DemographicInfo.value('declare namespace survey4="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; (/survey4:IndividualSurvey/survey4:Gender)[1]','varchar(50)') AS Gender,
DemographicInfo.value('declare namespace survey5="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; (/survey5:IndividualSurvey/survey5:Education)[1]','varchar(50)') AS Education


FROM People.PersonDetails
WHERE BusinessEntityID = 1735
;
*/