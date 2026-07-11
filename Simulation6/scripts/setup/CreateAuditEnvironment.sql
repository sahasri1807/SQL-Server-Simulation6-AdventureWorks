USE AdventureWorks2022;
GO

/*
========================================================
Task 1 - Audit Environment Development
Team Members:
Hassana - Training Schema and ProductPriceAudit
Kelvin - ProductDeletionAudit and DatabaseSchemaAudit
========================================================
*/

-- HASSANA PART
-- Create Training Schema
IF NOT EXISTS
(
    SELECT *
    FROM sys.schemas
    WHERE name = 'Training'
)
BEGIN
    EXEC('CREATE SCHEMA Training');
END;
GO
  
-- HASSANA PART
-- Create ProductPriceAudit Table

IF OBJECT_ID('Training.ProductPriceAudit', 'U') IS NULL
BEGIN
CREATE TABLE Training.ProductPriceAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_ProductPriceAudit PRIMARY KEY,

    ProductID INT NOT NULL,

    ProductName NVARCHAR(100) NOT NULL,

    PreviousPrice MONEY NOT NULL,

    UpdatedPrice MONEY NOT NULL,

    ModifiedBy NVARCHAR(128) NOT NULL,

    ChangeDate DATETIME2 
        CONSTRAINT DF_ProductPriceAudit_ChangeDate 
        DEFAULT SYSDATETIME()
);
END;
GO

-- KELVIN PART
-- Create ProductDeletionAudit Table

IF OBJECT_ID('Training.ProductDeletionAudit', 'U') IS NULL
BEGIN
CREATE TABLE Training.ProductDeletionAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_ProductDeletionAudit PRIMARY KEY,

    ProductID INT NOT NULL,

    ProductName NVARCHAR(100) NOT NULL,

    AttemptingUser NVARCHAR(128) NOT NULL,

    AttemptTime DATETIME2
        CONSTRAINT DF_ProductDeletionAudit_AttemptTime
        DEFAULT SYSDATETIME(),

    Reason NVARCHAR(255) NOT NULL
);
END;
GO

-- KELVIN PART
-- Create DatabaseSchemaAudit Table
IF OBJECT_ID('Training.DatabaseSchemaAudit', 'U') IS NULL
BEGIN
CREATE TABLE Training.DatabaseSchemaAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_DatabaseSchemaAudit PRIMARY KEY,

    EventType NVARCHAR(50) NOT NULL,

    ObjectName NVARCHAR(128) NOT NULL,

    LoginName NVARCHAR(128) NOT NULL,

    EventTime DATETIME2
        CONSTRAINT DF_DatabaseSchemaAudit_EventTime
        DEFAULT SYSDATETIME()
);
END;
GO

-- INDEXES

-- Hassana Part
CREATE INDEX IX_ProductPriceAudit_ProductID
ON Training.ProductPriceAudit(ProductID);
GO
  
-- Kelvin Part
CREATE INDEX IX_ProductDeletionAudit_ProductID
ON Training.ProductDeletionAudit(ProductID);
GO
  
-- Kelvin Part
CREATE INDEX IX_DatabaseSchemaAudit_EventType
ON Training.DatabaseSchemaAudit(EventType);
GO

-- VALIDATION
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Training';
GO
