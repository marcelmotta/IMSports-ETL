/** Script for creation of all necessary objects for the staging database */

USE [master];

--CREATE STAGING AREA DATABASE USING DEFAULT OPTIONS
CREATE DATABASE [IMSports_SalesSA];

USE [IMSports_SalesSA];

SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;

--CREATE CUSTOMER DIMENSION TABLE
CREATE TABLE [Stg_DimCustomer] (
    [SK_CustomerID] int identity PRIMARY KEY,
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
    [cusNumberOfEmployees] int
)

--CREATE LOCATION DIMENSION TABLE
CREATE TABLE [Stg_DimLocation] (
    [SK_LocationID] int identity PRIMARY KEY,
	[locBusinessID] int,
    [locCityName] nvarchar(50),
    [locPostalCode] nvarchar(50),
    [locStateName] nvarchar(50),
    [locCountry] nvarchar(50),
    [locSalesTerritoryName] nvarchar(50),
    [locSalesTerritoryGroup] nvarchar(50)
)

--CREATE PRODUCT DIMENSION TABLE
CREATE TABLE [Stg_DimProduct] (
    [SK_ProductID] int identity PRIMARY KEY,
    [proBusinessID] int,
    [proName] nvarchar(50),
    [proColor] nvarchar(50),
    [proDescription] nvarchar(50),
    [proCategory] nvarchar(50)
)

--CREATE SALESPERSON DIMENSION TABLE
CREATE TABLE [Stg_DimSalesPerson] (
    [SK_SalesPersonID] int identity PRIMARY KEY,
    [salBusinessID] int,
    [salName] nvarchar(256),
    [salYearsInCompany] int,
    [salTerritoryName] nvarchar(50),
    [salMaritalStatus] nvarchar(50),
    [salGender] nvarchar(50)
)

--CREATE TIME DIMENSION TABLE
CREATE TABLE [Stg_DimTime] (
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
CREATE TABLE [Stg_DimReason] (
    [SK_ReasonID] int identity PRIMARY KEY,
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
CREATE TABLE [Stg_FactSalesHeader] (
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
CREATE TABLE [Stg_FactSalesDetails] (
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
ALTER TABLE [dbo].[Stg_FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimCustomer] FOREIGN KEY([FK_CustomerID])
REFERENCES [dbo].[Stg_DimCustomer] ([SK_CustomerID])
;
ALTER TABLE [dbo].[Stg_FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimCustomer]
;

ALTER TABLE [dbo].[Stg_FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimLocation] FOREIGN KEY([FK_LocationID])
REFERENCES [dbo].[Stg_DimLocation] ([SK_LocationID])
;
ALTER TABLE [dbo].[Stg_FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimLocation]
;

ALTER TABLE [dbo].[Stg_FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimProduct] FOREIGN KEY([FK_ProductID])
REFERENCES [dbo].[Stg_DimProduct] ([SK_ProductID])
;
ALTER TABLE [dbo].[Stg_FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimProduct]
;

ALTER TABLE [dbo].[Stg_FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimReason] FOREIGN KEY([FK_ReasonID])
REFERENCES [dbo].[Stg_DimReason] ([SK_ReasonID])
;
ALTER TABLE [dbo].[Stg_FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimReason]
;

ALTER TABLE [dbo].[Stg_FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimSalesPerson] FOREIGN KEY([FK_SalesPersonID])
REFERENCES [dbo].[Stg_DimSalesPerson] ([SK_SalesPersonID])
;
ALTER TABLE [dbo].[Stg_FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimSalesPerson]
;

ALTER TABLE [dbo].[Stg_FactSalesDetails]  WITH CHECK ADD  CONSTRAINT [Measure_Details-DimTime] FOREIGN KEY([FK_TimeID])
REFERENCES [dbo].[Stg_DimTime] ([SK_TimeID])
;
ALTER TABLE [dbo].[Stg_FactSalesDetails] CHECK CONSTRAINT [Measure_Details-DimTime]
;


--ADD FOREIGN KEYS CONTRAINTS FOR FACTSALESHEADER
ALTER TABLE [dbo].[Stg_FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimCustomer] FOREIGN KEY([FK_CustomerID])
REFERENCES [dbo].[Stg_DimCustomer] ([SK_CustomerID])
;
ALTER TABLE [dbo].[Stg_FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimCustomer]
;

ALTER TABLE [dbo].[Stg_FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimLocation] FOREIGN KEY([FK_LocationID])
REFERENCES [dbo].[Stg_DimLocation] ([SK_LocationID])
;
ALTER TABLE [dbo].[Stg_FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimLocation]
;

ALTER TABLE [dbo].[Stg_FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimReason] FOREIGN KEY([FK_ReasonID])
REFERENCES [dbo].[Stg_DimReason] ([SK_ReasonID])
;
ALTER TABLE [dbo].[Stg_FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimReason]
;

ALTER TABLE [dbo].[Stg_FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimSalesPerson] FOREIGN KEY([FK_SalesPersonID])
REFERENCES [dbo].[Stg_DimSalesPerson] ([SK_SalesPersonID])
;
ALTER TABLE [dbo].[Stg_FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimSalesPerson]
;

ALTER TABLE [dbo].[Stg_FactSalesHeader]  WITH CHECK ADD  CONSTRAINT [Measure_Header-DimTime] FOREIGN KEY([FK_TimeID])
REFERENCES [dbo].[Stg_DimTime] ([SK_TimeID])
;
ALTER TABLE [dbo].[Stg_FactSalesHeader] CHECK CONSTRAINT [Measure_Header-DimTime]
;


--CREATE ETL LOG
CREATE TABLE [ETL_Log](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
    [ETL_Details] [nvarchar] (256),
    [ScheduleTime] [datetime]
    CONSTRAINT [PK_LogID] PRIMARY KEY CLUSTERED (
    [LogID] ASC
)
) 
ON [PRIMARY]
;

--CREATE ERROR LOG
CREATE TABLE [dbo].[Errors_Log](
    [ErrorID] [int] IDENTITY(1,1) NOT NULL,
    [ETL_Name] [nvarchar] (50),
    [Error] [nvarchar] (max),
    [Source] [nvarchar] (256)
) ON [PRIMARY]
;
