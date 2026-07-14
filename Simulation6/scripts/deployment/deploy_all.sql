-- ============================================================================
-- Owner: Sahasri (deployment)
-- ============================================================================
-- Task: Master deployment script for Simulation 6
-- ============================================================================

USE AdventureWorks2022;
GO

SET NOCOUNT ON;
GO


-- ============================================================================
-- TASK 1 - CREATE AUDIT ENVIRONMENT
-- ============================================================================

IF SCHEMA_ID(N'Training') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA Training;');
END;
GO


-- Product Price Audit Table

IF OBJECT_ID(N'Training.ProductPriceAudit', N'U') IS NULL
BEGIN

CREATE TABLE Training.ProductPriceAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_ProductPriceAudit PRIMARY KEY,

    ProductID INT NOT NULL,

    OldPrice MONEY NOT NULL,

    NewPrice MONEY NOT NULL,

    ChangedBy NVARCHAR(256) NOT NULL,

    ChangeDate DATETIME2
        CONSTRAINT DF_ProductPriceAudit_ChangeDate
        DEFAULT SYSUTCDATETIME()
);

END;
GO



-- Product Delete Audit Table

IF OBJECT_ID(N'Training.ProductDeletionAudit', N'U') IS NULL
BEGIN

CREATE TABLE Training.ProductDeletionAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_ProductDeletionAudit PRIMARY KEY,

    ProductID INT NOT NULL,

    ProductName NVARCHAR(100) NOT NULL,

    AttemptedBy NVARCHAR(256) NOT NULL,

    AttemptDate DATETIME2
        CONSTRAINT DF_ProductDeletionAudit_AttemptDate
        DEFAULT SYSUTCDATETIME(),

    Reason NVARCHAR(255) NOT NULL
);

END;
GO



-- Database Schema Audit Table

IF OBJECT_ID(N'Training.DatabaseSchemaAudit', N'U') IS NULL
BEGIN

CREATE TABLE Training.DatabaseSchemaAudit
(
    AuditID INT IDENTITY(1,1)
        CONSTRAINT PK_DatabaseSchemaAudit PRIMARY KEY,

    EventType NVARCHAR(100) NOT NULL,

    ObjectName NVARCHAR(256) NOT NULL,

    LoginName NVARCHAR(256),

    EventDate DATETIME2
        CONSTRAINT DF_DatabaseSchemaAudit_EventDate
        DEFAULT SYSUTCDATETIME()
);

END;
GO



-- Indexes

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_ProductPriceAudit_ProductID'
)
BEGIN
    CREATE INDEX IX_ProductPriceAudit_ProductID
    ON Training.ProductPriceAudit(ProductID);
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_ProductDeletionAudit_ProductID'
)
BEGIN
    CREATE INDEX IX_ProductDeletionAudit_ProductID
    ON Training.ProductDeletionAudit(ProductID);
END;
GO


IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_DatabaseSchemaAudit_EventType'
)
BEGIN
    CREATE INDEX IX_DatabaseSchemaAudit_EventType
    ON Training.DatabaseSchemaAudit(EventType);
END;
GO



-- ============================================================================
-- TASK 2 - AFTER UPDATE PRICE AUDIT TRIGGER
-- ============================================================================


DROP TRIGGER IF EXISTS Production.trg_Product_PriceAudit;
GO


CREATE TRIGGER Production.trg_Product_PriceAudit
ON Production.Product
AFTER UPDATE
AS
BEGIN

    SET NOCOUNT ON;


    IF NOT UPDATE(ListPrice)
        RETURN;


    INSERT INTO Training.ProductPriceAudit
    (
        ProductID,
        OldPrice,
        NewPrice,
        ChangedBy
    )

    SELECT
        i.ProductID,
        d.ListPrice,
        i.ListPrice,
        ISNULL(SUSER_SNAME(), ORIGINAL_LOGIN())

    FROM inserted i

    INNER JOIN deleted d
        ON i.ProductID = d.ProductID

    WHERE d.ListPrice <> i.ListPrice;

END;
GO


DENY UPDATE, DELETE 
ON Training.ProductPriceAudit 
TO PUBLIC;
GO



-- ============================================================================
-- TASK 3 - INSTEAD OF DELETE TRIGGER
-- ============================================================================


DROP TRIGGER IF EXISTS Production.trg_Product_PreventDelete;
GO


CREATE TRIGGER Production.trg_Product_PreventDelete
ON Production.Product
INSTEAD OF DELETE
AS
BEGIN

    SET NOCOUNT ON;


    INSERT INTO Training.ProductDeletionAudit
    (
        ProductID,
        ProductName,
        AttemptedBy,
        Reason
    )

    SELECT
        d.ProductID,
        d.Name,
        ISNULL(SUSER_SNAME(), ORIGINAL_LOGIN()),
        'Deletion prevented: Product is referenced by customer transactions.'

    FROM deleted d

    WHERE EXISTS
    (
        SELECT 1
        FROM Sales.SalesOrderDetail s
        WHERE s.ProductID = d.ProductID
    );



    DELETE p

    FROM Production.Product p

    INNER JOIN deleted d
        ON p.ProductID = d.ProductID

    WHERE NOT EXISTS
    (
        SELECT 1
        FROM Sales.SalesOrderDetail s
        WHERE s.ProductID = d.ProductID
    );

END;
GO



-- ============================================================================
-- TASK 4 - DATABASE DDL AUDIT TRIGGER
-- ============================================================================


DROP TRIGGER IF EXISTS trg_Database_SchemaAudit
ON DATABASE;
GO


CREATE TRIGGER trg_Database_SchemaAudit
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN

    SET NOCOUNT ON;


    DECLARE @EventData XML;

    SET @EventData = EVENTDATA();


    INSERT INTO Training.DatabaseSchemaAudit
    (
        EventType,
        ObjectName,
        LoginName,
        EventDate
    )

    VALUES
    (
        @EventData.value(
        '(/EVENT_INSTANCE/EventType)[1]',
        'NVARCHAR(100)'
        ),

        @EventData.value(
        '(/EVENT_INSTANCE/ObjectName)[1]',
        'NVARCHAR(256)'
        ),

        SUSER_SNAME(),

        SYSUTCDATETIME()
    );

END;
GO



-- ============================================================================
-- TASK 5 - RECURSIVE TRIGGER DEMO
-- ============================================================================


IF OBJECT_ID(N'Training.RecursiveTriggerDemo','U') IS NULL
BEGIN

CREATE TABLE Training.RecursiveTriggerDemo
(
    DemoID INT IDENTITY(1,1) PRIMARY KEY,

    DemoValue INT NOT NULL DEFAULT 0,

    TriggerCount INT NOT NULL DEFAULT 0,

    LastModified DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

END;
GO



IF OBJECT_ID(N'Training.RecursiveTriggerDemoLog','U') IS NULL
BEGIN

CREATE TABLE Training.RecursiveTriggerDemoLog
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,

    DemoID INT NOT NULL,

    TriggerInvocation INT NOT NULL,

    EventTime DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    LoginName SYSNAME DEFAULT SUSER_SNAME()
);

END;
GO



DROP TRIGGER IF EXISTS Training.trg_RecursiveTriggerDemo;
GO


CREATE TRIGGER Training.trg_RecursiveTriggerDemo
ON Training.RecursiveTriggerDemo
AFTER UPDATE
AS
BEGIN

    SET NOCOUNT ON;


    IF TRIGGER_NESTLEVEL() > 1
        RETURN;



    INSERT INTO Training.RecursiveTriggerDemoLog
    (
        DemoID,
        TriggerInvocation
    )

    SELECT
        DemoID,
        1

    FROM inserted;



    UPDATE t

    SET
        TriggerCount = TriggerCount + 1,
        LastModified = SYSUTCDATETIME()

    FROM Training.RecursiveTriggerDemo t

    INNER JOIN inserted i

        ON t.DemoID = i.DemoID;


END;
GO



-- ============================================================================
-- TASK 6 - REPORT ACCESS
-- ============================================================================


IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name='AuditReader'
)
BEGIN

CREATE ROLE AuditReader;

END;
GO


GRANT SELECT ON Training.ProductPriceAudit TO AuditReader;

GRANT SELECT ON Training.ProductDeletionAudit TO AuditReader;

GRANT SELECT ON Training.DatabaseSchemaAudit TO AuditReader;
GO



PRINT 'Simulation 6 deployment completed successfully.';
GO