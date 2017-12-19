/** Script for creation of all necessary objects for the Data Warehouse */

USE [master];

--CREATE DATA WAREHOUSE DATABASE USING DEFAULT OPTIONS
CREATE DATABASE [IMSports_SalesDW];

USE [IMSports_SalesDW];

SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;

--CREATE CUSTOMER DIMENSION TABLE
CREATE TABLE [DimCustomer] (
    [SK_CustomerID] int PRIMARY KEY,
    [cusBusinessID] int,
    [cusCategory] nvarchar(50),
    [cusAge] int,
    [cusMaritalStatus] nvarchar(50),
    [cusYearlyIncome] nvarchar(50),
    [cusGender] nvarchar(50),
    [cusNumberOfChildren] nvarchar(50),
    [cusNumberOfChildrenAtHome] nvarchar(50),
    [cusEducation] nvarchar(50),
    [cusOccupation] nvarchar(50),
    [cusHomeOwnerFlag] nvarchar(50),
    [cusNumberOfCarsOwned] nvarchar(50),
    [cusCommuteDistance] nvarchar(50),
    [cusAnnualSales] int,
    [cusAnnualRevenue] int,
    [cusBusinessType] nvarchar(50),
    [cusYearsOfOperation] int,
    [cusSpecialty] nvarchar(50),
    [cusSquareFeet] int,
    [cusBrands] nvarchar(50),
    [cusInternetConnection] nvarchar(50),
    [cusNumberOfEmployees] int,
	[cusSCD_StartDate] datetime,
	[cusSCD_EndDate] datetime
)

--CREATE LOCATION DIMENSION TABLE
CREATE TABLE [DimLocation] (
    [SK_LocationID] int PRIMARY KEY,
	[locBusinessID] int,
    [locCityName] nvarchar(50),
    [locPostalCode] nvarchar(50),
    [locStateName] nvarchar(50),
    [locCountry] nvarchar(50),
    [locSalesTerritoryName] nvarchar(50),
    [locSalesTerritoryGroup] nvarchar(50)
)

--CREATE PRODUCT DIMENSION TABLE
CREATE TABLE [DimProduct] (
    [SK_ProductID] int PRIMARY KEY,
    [proBusinessID] int,
    [proName] nvarchar(50),
    [proColor] nvarchar(50),
    [proDescription] nvarchar(50),
    [proCategory] nvarchar(50)
)

--CREATE SALESPERSON DIMENSION TABLE
CREATE TABLE [DimSalesPerson] (
    [SK_SalesPersonID] int PRIMARY KEY,
    [salBusinessID] int,
    [salName] nvarchar(256),
    [salYearsInCompany] int,
    [salTerritoryName] nvarchar(50),
    [salMaritalStatus] nvarchar(50),
    [salGender] nvarchar(50),
	[salSCD_StartDate] datetime,
	[salSCD_EndDate] datetime
)

--CREATE TIME DIMENSION TABLE
CREATE TABLE [DimTime] (
    [SK_TimeID] int PRIMARY KEY,
    [timYear] int,
    [timMonth] int,
    [timDay] int,
    [timQuarter] int,
    [timSeason] nvarchar(50),
    [timWeekday] int,
    [timDayOfWeek] nvarchar(50)
)

--CREATE REASON DIMENSION TABLE
CREATE TABLE [DimReason] (
    [SK_ReasonID] int PRIMARY KEY,
    [Price] bit,
    [OnPromotion] bit,
    [MagazineAdvertisement] bit,
    [TelevisionAdvertisement] bit,
    [Manufacturer] bit,
    [Review] bit,
    [DemoEvent] bit,
    [Sponsorship] bit,
    [Quality] bit,
    [Other] bit
)

--CREATE FACTSALESHEADER
CREATE TABLE [FactSalesHeader] (
    [FK_CustomerID] int,
    [FK_LocationID] int,
    [FK_ReasonID] int,
	[FK_SalesPersonID] int,
    [FK_TimeID] int,
    [SubTotal] money,
    
	CONSTRAINT [PK_Measure_Header] PRIMARY KEY CLUSTERED (
	[FK_CustomerID] ASC,
	[FK_LocationID] ASC,
	[FK_ReasonID] ASC,
	[FK_SalesPersonID] ASC,
	[FK_TimeID] ASC
)
)
ON [PRIMARY]
;

--CREATE FACTSALESDETAILS
CREATE TABLE [FactSalesDetails] (
	[FK_CustomerID] int,
	[FK_LocationID] int,
	[FK_ProductID] int,
	[FK_ReasonID] int,
	[FK_SalesPersonID] int,
    [FK_TimeID] int,
    [OrderQty] int,
    [UnitPrice] money,
	[UnitPriceDiscount] decimal(10,2),
    [LineTotal] money,

    CONSTRAINT [PK_Measure_Details] PRIMARY KEY CLUSTERED (
	[FK_CustomerID] ASC,
	[FK_LocationID] ASC,
	[FK_ProductID] ASC,
	[FK_ReasonID] ASC,
	[FK_SalesPersonID] ASC,
    [FK_TimeID] ASC
)
)  
ON [PRIMARY]
;


--ADD FOREIGN KEYS CONTRAINTS FOR FACTSALESDETAILS
ALTER TABLE [dbo].[FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimCustomer] FOREIGN KEY([FK_CustomerID])
REFERENCES [dbo].[DimCustomer] ([SK_CustomerID])
;
ALTER TABLE [dbo].[FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimCustomer]
;

ALTER TABLE [dbo].[FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimLocation] FOREIGN KEY([FK_LocationID])
REFERENCES [dbo].[DimLocation] ([SK_LocationID])
;
ALTER TABLE [dbo].[FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimLocation]
;

ALTER TABLE [dbo].[FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimProduct] FOREIGN KEY([FK_ProductID])
REFERENCES [dbo].[DimProduct] ([SK_ProductID])
;
ALTER TABLE [dbo].[FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimProduct]
;

ALTER TABLE [dbo].[FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimReason] FOREIGN KEY([FK_ReasonID])
REFERENCES [dbo].[DimReason] ([SK_ReasonID])
;
ALTER TABLE [dbo].[FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimReason]
;

ALTER TABLE [dbo].[FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimSalesPerson] FOREIGN KEY([FK_SalesPersonID])
REFERENCES [dbo].[DimSalesPerson] ([SK_SalesPersonID])
;
ALTER TABLE [dbo].[FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimSalesPerson]
;

ALTER TABLE [dbo].[FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimTime] FOREIGN KEY([FK_TimeID])
REFERENCES [dbo].[DimTime] ([SK_TimeID])
;
ALTER TABLE [dbo].[FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimTime]
;


--ADD FOREIGN KEYS CONTRAINTS FOR FACTSALESHEADER
ALTER TABLE [dbo].[FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimCustomer] FOREIGN KEY([FK_CustomerID])
REFERENCES [dbo].[DimCustomer] ([SK_CustomerID])
;
ALTER TABLE [dbo].[FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimCustomer]
;

ALTER TABLE [dbo].[FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimLocation] FOREIGN KEY([FK_LocationID])
REFERENCES [dbo].[DimLocation] ([SK_LocationID])
;
ALTER TABLE [dbo].[FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimLocation]
;

ALTER TABLE [dbo].[FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimReason] FOREIGN KEY([FK_ReasonID])
REFERENCES [dbo].[DimReason] ([SK_ReasonID])
;
ALTER TABLE [dbo].[FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimReason]
;

ALTER TABLE [dbo].[FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimSalesPerson] FOREIGN KEY([FK_SalesPersonID])
REFERENCES [dbo].[DimSalesPerson] ([SK_SalesPersonID])
;
ALTER TABLE [dbo].[FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimSalesPerson]
;

ALTER TABLE [dbo].[FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimTime] FOREIGN KEY([FK_TimeID])
REFERENCES [dbo].[DimTime] ([SK_TimeID])
;
ALTER TABLE [dbo].[FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimTime]
;


--ENABLE TABLE COMPRESSION FOR FACT TABLES
ALTER TABLE [dbo].[FactSalesDetails]
REBUILD WITH (DATA_COMPRESSION = PAGE)
EXEC sp_estimate_data_compression_savings 'dbo',
'FactSalesDetails', NULL, NULL, 'PAGE'
;
ALTER TABLE [dbo].[FactSalesHeader]
REBUILD WITH (DATA_COMPRESSION = PAGE)
EXEC sp_estimate_data_compression_savings 'dbo',
'FactSalesHeader', NULL, NULL, 'PAGE'
;

