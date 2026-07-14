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

CREATE TABLE Training.ProductPriceAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_ProductPriceAudit PRIMARY KEY,

    ProductID INT NOT NULL,

    ProductName NVARCHAR(100) NOT NULL,

    OldPrice MONEY NOT NULL,

    NewPrice MONEY NOT NULL,

    ChangedBy NVARCHAR(128)
        CONSTRAINT DF_ProductPriceAudit_ChangedBy
        DEFAULT SUSER_SNAME(),

    ChangeDate DATETIME2
        CONSTRAINT DF_ProductPriceAudit_ChangeDate
        DEFAULT SYSUTCDATETIME()
);
GO

ALTER TABLE Training.ProductPriceAudit
ADD CONSTRAINT FK_ProductPriceAudit_Product
FOREIGN KEY(ProductID)
REFERENCES Production.Product(ProductID);
GO

CREATE TABLE Training.ProductDeletionAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_ProductDeletionAudit PRIMARY KEY,

    ProductID INT NOT NULL,

    ProductName NVARCHAR(100) NOT NULL,

    AttemptedBy NVARCHAR(128)
        CONSTRAINT DF_ProductDeletionAudit_AttemptedBy
        DEFAULT SUSER_SNAME(),

    AttemptDate DATETIME2
        CONSTRAINT DF_ProductDeletionAudit_AttemptDate
        DEFAULT SYSUTCDATETIME(),

    Reason NVARCHAR(250) NOT NULL
);
GO

ALTER TABLE Training.ProductDeletionAudit
ADD CONSTRAINT FK_ProductDeletionAudit_Product
FOREIGN KEY(ProductID)
REFERENCES Production.Product(ProductID);
GO

CREATE TABLE Training.DatabaseSchemaAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_DatabaseSchemaAudit PRIMARY KEY,

    EventType NVARCHAR(50) NOT NULL,

    ObjectName NVARCHAR(128) NOT NULL,

    LoginName NVARCHAR(128)
        CONSTRAINT DF_DatabaseSchemaAudit_LoginName
        DEFAULT SUSER_SNAME(),

    EventDate DATETIME2
        CONSTRAINT DF_DatabaseSchemaAudit_EventDate
        DEFAULT SYSUTCDATETIME()
);
GO

CREATE INDEX IX_ProductPriceAudit_Product
ON Training.ProductPriceAudit(ProductID);
GO

CREATE INDEX IX_ProductDeletionAudit_Product
ON Training.ProductDeletionAudit(ProductID);
GO

CREATE INDEX IX_DatabaseSchemaAudit_EventType
ON Training.DatabaseSchemaAudit(EventType);
GO