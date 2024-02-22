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
