-- ============================================================================
-- Owner: Sahasri (deployment)
-- ============================================================================
-- Task: Master deployment script for all Simulation6 objects.
-- Implementation: This script runs the project scripts in order.
-- ============================================================================

USE AdventureWorks2022;
GO

SET NOCOUNT ON;
GO

-- Task 1 - Audit environment
IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Training'
)
BEGIN
    EXEC(N'CREATE SCHEMA Training;');
END;
GO

IF OBJECT_ID(N'Training.ProductPriceAudit', N'U') IS NULL
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
            CONSTRAINT DF_ProductPriceAudit_ChangeDate DEFAULT SYSDATETIME()
    );
END;
GO

IF OBJECT_ID(N'Training.ProductDeletionAudit', N'U') IS NULL
BEGIN
    CREATE TABLE Training.ProductDeletionAudit
    (
        AuditID INT IDENTITY(1,1)
            CONSTRAINT PK_ProductDeletionAudit PRIMARY KEY,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(100) NOT NULL,
        AttemptingUser NVARCHAR(128) NOT NULL,
        AttemptTime DATETIME2
            CONSTRAINT DF_ProductDeletionAudit_AttemptTime DEFAULT SYSDATETIME(),
        Reason NVARCHAR(255) NOT NULL
    );
END;
GO

IF OBJECT_ID(N'Training.DatabaseSchemaAudit', N'U') IS NULL
BEGIN
    CREATE TABLE Training.DatabaseSchemaAudit
    (
        AuditID INT IDENTITY(1,1)
            CONSTRAINT PK_DatabaseSchemaAudit PRIMARY KEY,
        EventType NVARCHAR(50) NOT NULL,
        ObjectName NVARCHAR(128) NOT NULL,
        LoginName NVARCHAR(128) NOT NULL,
        EventTime DATETIME2
            CONSTRAINT DF_DatabaseSchemaAudit_EventTime DEFAULT SYSDATETIME()
    );
END;
GO

CREATE INDEX IX_ProductPriceAudit_ProductID
ON Training.ProductPriceAudit(ProductID);
GO

CREATE INDEX IX_ProductDeletionAudit_ProductID
ON Training.ProductDeletionAudit(ProductID);
GO

CREATE INDEX IX_DatabaseSchemaAudit_EventType
ON Training.DatabaseSchemaAudit(EventType);
GO

-- Task 2 - After UPDATE trigger
DROP TRIGGER IF EXISTS Production.trg_Product_PriceAudit;
GO

CREATE OR ALTER TRIGGER trg_Product_PriceAudit
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
        ProductName,
        PreviousPrice,
        UpdatedPrice,
        ModifiedBy
    )
    SELECT
        i.ProductID,
        i.Name,
        d.ListPrice,
        i.ListPrice,
        ISNULL(SUSER_SNAME(), ORIGINAL_LOGIN())
    FROM inserted AS i
    INNER JOIN deleted AS d
        ON d.ProductID = i.ProductID
    WHERE d.ListPrice <> i.ListPrice;
END;
GO

DENY UPDATE, DELETE ON Training.ProductPriceAudit TO PUBLIC;
GO

-- Task 3 - INSTEAD OF DELETE trigger placeholder
PRINT 'InsteadOfDelete trigger script is present for future implementation.';
GO

-- Task 4 - DDL trigger
CREATE OR ALTER TRIGGER trg_Database_SchemaAudit
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
        EventTime
    )
    VALUES
    (
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(50)'),
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(128)'),
        SUSER_SNAME(),
        SYSUTCDATETIME()
    );
END;
GO

PRINT 'trg_Database_SchemaAudit created successfully.';
GO

-- Task 5 - Dhruv: Recursive trigger demo
IF SCHEMA_ID(N'Training') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA Training;');
END;
GO

IF OBJECT_ID(N'Training.RecursiveTriggerDemo', N'U') IS NULL
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

IF OBJECT_ID(N'Training.RecursiveTriggerDemoLog', N'U') IS NULL
BEGIN
    CREATE TABLE Training.RecursiveTriggerDemoLog
    (
        EventID INT IDENTITY(1,1) PRIMARY KEY,
        DemoID INT NOT NULL,
        TriggerInvocation INT NOT NULL,
        EventTime DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        LoginName SYSNAME NOT NULL DEFAULT SUSER_SNAME()
    );
END;
GO

IF OBJECT_ID(N'Training.trg_RecursiveTriggerDemo', N'TR') IS NULL
BEGIN
    CREATE TRIGGER Training.trg_RecursiveTriggerDemo
    ON Training.RecursiveTriggerDemo
    AFTER UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF TRIGGER_NESTLEVEL() > 1
        BEGIN
            RETURN;
        END;

        INSERT INTO Training.RecursiveTriggerDemoLog (DemoID, TriggerInvocation)
        SELECT DemoID, COALESCE((SELECT MAX(TriggerInvocation) FROM Training.RecursiveTriggerDemoLog WHERE DemoID = i.DemoID), 0) + 1
        FROM inserted AS i;

        UPDATE t
        SET TriggerCount = t.TriggerCount + 1,
            LastModified = SYSUTCDATETIME()
        FROM Training.RecursiveTriggerDemo AS t
        INNER JOIN inserted AS i
            ON t.DemoID = i.DemoID
        WHERE t.TriggerCount < 2;
    END;
END;
GO

PRINT 'Task 5 objects created. Run RecursiveTriggerDemo.sql to execute the demo.';
GO

-- Task 6 - Audit reports
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AuditReader' AND type = 'R')
BEGIN
    CREATE ROLE AuditReader;
END;
GO

GRANT SELECT ON Training.ProductPriceAudit TO AuditReader;
GRANT SELECT ON Training.ProductDeletionAudit TO AuditReader;
GO

DECLARE @FromDate DATETIME2 = '1900-01-01';
DECLARE @ToDate DATETIME2 = SYSDATETIME();
DECLARE @MaxRows INT = 10000;

SELECT TOP (@MaxRows)
    ppa.AuditID,
    ppa.ProductID,
    ppa.ProductName,
    ppa.PreviousPrice AS OldPrice,
    ppa.UpdatedPrice AS NewPrice,
    ppa.UpdatedPrice - ppa.PreviousPrice AS PriceDifference,
    ppa.ModifiedBy AS ChangedBy,
    ppa.ChangeDate
FROM Training.ProductPriceAudit AS ppa
WHERE ppa.ChangeDate >= @FromDate
  AND ppa.ChangeDate <= @ToDate
ORDER BY ppa.ChangeDate DESC;
GO

DECLARE @FromDate2 DATETIME2 = '1900-01-01';
DECLARE @ToDate2 DATETIME2 = SYSDATETIME();
DECLARE @MaxRows2 INT = 10000;

SELECT TOP (@MaxRows2)
    pda.AuditID,
    pda.ProductID,
    pda.ProductName,
    pda.AttemptingUser AS AttemptedBy,
    pda.AttemptTime AS AttemptDate,
    pda.Reason
FROM Training.ProductDeletionAudit AS pda
WHERE pda.AttemptTime >= @FromDate2
  AND pda.AttemptTime <= @ToDate2
ORDER BY pda.AttemptTime DESC;
GO
