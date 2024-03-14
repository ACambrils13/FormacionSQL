-- create smcdb1 database
USE master;
GO
CREATE DATABASE smcdb1
COLLATE Modern_Spanish_CI_AI;
GO

-- create table Test on smcdb1 with primary key
USE smcdb1;
GO
CREATE TABLE Test (
	Code VARCHAR(20) NOT NULL PRIMARY KEY
);
GO


-- create smcdb2 database
USE master;
GO
CREATE DATABASE smcdb2
COLLATE Latin1_General_CS_AS;
GO


-- create column for distinct types on table Test
USE smcdb1;
GO
ALTER TABLE Test
ADD bit_column BIT,
    tinyint_column TINYINT,
	smallint_column SMALLINT,
	int_column INT,
	bigint_column BIGINT,
	decimal_column DECIMAL(10, 2),
	numeric_colimn NUMERIC,
	smallmoney_column SMALLMONEY,
	money_column MONEY,
	real_column REAL,
    float_column FLOAT(24),
    date_column DATE,
    datetime_column DATETIME,
    datetime2_column DATETIME2,
	datetimeoffset_column DATETIMEOFFSET,
    smalldatetime_column SMALLDATETIME,
    time_column TIME,
    char_column CHAR(10),
    varchar_column VARCHAR(255),
    text_column TEXT,
    nchar_column NCHAR(10),
    nvarchar_column NVARCHAR(255),
    ntext_column NTEXT,
    binary_column BINARY(10),
    varbinary_column VARBINARY(255),
    image_column IMAGE,
	rowversion_column ROWVERSION,
	hierarchyid_column HIERARCHYID,
    uniqueidentifier_column UNIQUEIDENTIFIER,
    xml_column XML,
    geography_column GEOGRAPHY,
    geometry_column GEOMETRY;
GO


-- create test data
USE [smcdb1]
GO

INSERT INTO [dbo].[Test]
           ([Code]
           ,[bit_column]
           ,[tinyint_column]
           ,[smallint_column]
           ,[int_column]
           ,[bigint_column]
           ,[decimal_column]
           ,[numeric_colimn]
           ,[smallmoney_column]
           ,[money_column]
           ,[real_column]
           ,[float_column]
           ,[date_column]
           ,[datetime_column]
           ,[datetime2_column]
           ,[datetimeoffset_column]
           ,[smalldatetime_column]
           ,[time_column]
           ,[char_column]
           ,[varchar_column]
           ,[text_column]
           ,[nchar_column]
           ,[nvarchar_column]
           ,[ntext_column]
           ,[binary_column]
           ,[varbinary_column]
           ,[image_column]
           ,[hierarchyid_column]
           ,[uniqueidentifier_column]
           ,[xml_column]
           ,[geography_column]
           ,[geometry_column])
     VALUES
           ('A001', 1, 253, -25100, 987632, 8856324125637, 1234.56, 123456789012345678, 12.34, 123.45, 3.14, 3.14159, '2024-02-22', '2024-02-22T12:34:56', '2024-02-22T12:34:56.7898124', '2024-02-22T12:34:56.8912384+05:30', '2024-02-22T12:34:00', '12:34:56', 'abc', 'Este es un varchar', 'Este es un texto', 'abc', 'Este es un Nvarchar', 'Este es un Ntexto', 0x0102030405, 0x010203, NULL, NULL, NEWID(), '<root><child>datos</child></root>', geography::STGeomFromText('POINT(-122.34900 47.65100)', 4326), geometry::STGeomFromText('POINT(-122.34900 47.65100)', 0)),
		   ('A002', 0, 3, 1268, -1256978, -3695211569785216, 9876.54, -987654321098765432, 0.56, -678.90, -2.71, -2.71828, '2024-02-23', '2024-02-23T01:23:45', '2024-02-23T01:23:45.1234567', '2024-02-23T01:23:45.1253467-07:00', '2024-02-23T01:23:00', '01:23:45', 'abc', 'Este es un varchar', 'Este es un texto', 'def', 'Este es otro Nvarchar', 'Este es otro Ntexto', 0x0504030201, 0x050403, NULL, NULL, NEWID(), '<root><child>m�s datos</child></root>', geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 4326), geometry::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 0))
		   ;
GO


-- copy table test from smcdb1 to smcdb2
SELECT *
INTO smcdb2.dbo.Test
FROM smcdb1.dbo.Test;
GO


-- join between tables
SELECT *
FROM smcdb1.dbo.Test AS t1
INNER JOIN smcdb2.dbo.Test AS t2
	ON t1.nvarchar_column COLLATE Latin1_General_CS_AS = t2.nvarchar_column



-- create tables Sales on smcdb1
USE smcdb1;
GO

CREATE SCHEMA Sales;
GO

CREATE TABLE Sales.Customers (
    CustomerId UNIQUEIDENTIFIER PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    DocumentNumber VARCHAR(15) UNIQUE NOT NULL
);
GO

CREATE TABLE Sales.Countries (
    CountryId UNIQUEIDENTIFIER PRIMARY KEY,
    CountryName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Sales.Address (
    AddressId UNIQUEIDENTIFIER PRIMARY KEY,
    Street NVARCHAR(100),
    City NVARCHAR(100) NOT NULL,
    CountryId UNIQUEIDENTIFIER,
    FOREIGN KEY (CountryId) REFERENCES Sales.Countries(CountryId)
);
GO

CREATE TABLE Sales.Products (
    ProductId UNIQUEIDENTIFIER PRIMARY KEY,
    Name NVARCHAR(100)
);
GO

CREATE TABLE Sales.InvoicesHeader (
	InvoiceId UNIQUEIDENTIFIER PRIMARY KEY,
    InvoiceDate DATETIME DEFAULT GETDATE(),
    CustomerId UNIQUEIDENTIFIER,
    AddressId UNIQUEIDENTIFIER,
    TaxBase MONEY NOT NULL,
    TotalVat MONEY NOT NULL,
    Total MONEY NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Sales.Customers(CustomerId),
    FOREIGN KEY (AddressId) REFERENCES Sales.Address(AddressId),
);
GO

CREATE TABLE Sales.VatTypes (
    VatTypeId INT PRIMARY KEY,
    VatName VARCHAR(30),
    VatCost DECIMAL(5,2) NOT NULL
);
GO

CREATE TABLE Sales.InvoicesDetail (
    InvoiceId UNIQUEIDENTIFIER,
    RowNumber INT,
    ProductId UNIQUEIDENTIFIER,
    Description NVARCHAR(100),
    Quantity INT NOT NULL,
    UnitPrice MONEY NOT NULL,
    Discount DECIMAL(5,2),
    VatTypeId INT,
    TotalLine MONEY NOT NULL
    PRIMARY KEY (InvoiceId, RowNumber)
    FOREIGN KEY (VatTypeId) REFERENCES Sales.VatTypes(VatTypeId),
    FOREIGN KEY (ProductId) REFERENCES Sales.Products(ProductId),
    FOREIGN KEY (InvoiceId) REFERENCES Sales.InvoicesHeader(InvoiceId)
);
GO

-- create triggers to actualice Sales.InvoicesDetail.TotalLine
USE smcdb1;
GO

-- insert / update on Sales.InvoicesDetail
CREATE OR ALTER TRIGGER UpdateTotalOnUpdateDetail
ON Sales.InvoicesDetail
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(Quantity) OR UPDATE(UnitPrice) OR UPDATE(Discount) OR UPDATE(VatTypeId)
    BEGIN
        UPDATE Sales.InvoicesDetail
        SET TotalLine = inserted.Quantity * ((inserted.UnitPrice * ((100 - ISNULL(inserted.Discount, 0)) / 100)) + ((inserted.UnitPrice * ((100 - ISNULL(inserted.Discount, 0)) / 100)) * (ISNULL((SELECT VatCost FROM Sales.VatTypes WHERE VatTypeId = inserted.VatTypeId), 0) / 100)))
        FROM inserted
        WHERE Sales.InvoicesDetail.InvoiceId = inserted.InvoiceId AND Sales.InvoicesDetail.RowNumber = inserted.RowNumber;
    END;

    BEGIN
        UPDATE inh
        SET TaxBase = (SELECT SUM(ind.Quantity * ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100)))) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
            , TotalVat = (SELECT SUM(ind.TotalLine - (ind.Quantity * ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100))))) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
            , Total = (SELECT SUM(ind.TotalLine) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
        FROM Sales.InvoicesHeader AS inh
        INNER JOIN inserted ON inserted.InvoiceId = inh.InvoiceId
    END;
END;
GO

-- delete on Sales.InvoicesDetail
CREATE OR ALTER TRIGGER UpdateInvoicesHeaderOnDeleteDetail
ON Sales.InvoicesDetail
AFTER DELETE
AS
BEGIN
    UPDATE inh
    SET TaxBase = (SELECT SUM(ind.Quantity * ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100)))) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
        , TotalVat = (SELECT SUM(ind.TotalLine - (ind.Quantity * ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100))))) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
        , Total = (SELECT SUM(ind.TotalLine) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
    FROM Sales.InvoicesHeader AS inh
    INNER JOIN deleted ON deleted.InvoiceId = inh.InvoiceId
END;
GO

-- update on Sales.VatTypes
CREATE OR ALTER TRIGGER UpdateTotalOnUpdateVatCost
ON Sales.VatTypes
AFTER UPDATE
AS
BEGIN
    IF UPDATE(VatCost)
    BEGIN
        UPDATE ind
        SET TotalLine = ind.Quantity * ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100)) + ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100)) * (ISNULL((SELECT VatCost FROM Sales.VatTypes WHERE VatTypeId = ind.VatTypeId), 0) / 100)))
        FROM Sales.InvoicesDetail AS ind
        INNER JOIN inserted ON ind.VatTypeId = inserted.VatTypeId
    END;

    BEGIN
        UPDATE inh
        SET TaxBase = (SELECT SUM(ind.Quantity * ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100)))) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
            , TotalVat = (SELECT SUM(ind.TotalLine - (ind.Quantity * ((ind.UnitPrice * ((100 - ISNULL(ind.Discount, 0)) / 100))))) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
            , Total = (SELECT SUM(ind.TotalLine) FROM Sales.InvoicesDetail AS ind WHERE ind.InvoiceId = inh.InvoiceId)
        FROM Sales.InvoicesHeader AS inh
        INNER JOIN Sales.InvoicesDetail AS ind ON ind.InvoiceId = inh.InvoiceId
        INNER JOIN inserted ON inserted.VatTypeId = ind.VatTypeId
    END;
END;
GO