-- ============================================================================
-- Owner: Dhruv (Task 5 - recursive trigger demo)
-- ============================================================================
-- Task: Demonstrate recursive trigger behavior and mitigation.
-- Implementation: This script creates a small demo table, a trigger that
-- updates the same table, and a validation query that shows whether the
-- trigger fired recursively when recursive triggers are enabled.
-- ============================================================================

USE AdventureWorks2022;
GO

SET NOCOUNT ON;
GO

IF SCHEMA_ID(N'Training') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA Training;');
END;
GO

IF OBJECT_ID(N'Training.trg_RecursiveTriggerDemo', N'TR') IS NOT NULL
BEGIN
    DROP TRIGGER Training.trg_RecursiveTriggerDemo;
END;
GO

IF OBJECT_ID(N'Training.RecursiveTriggerDemoLog', N'U') IS NOT NULL
BEGIN
    DROP TABLE Training.RecursiveTriggerDemoLog;
END;
GO

IF OBJECT_ID(N'Training.RecursiveTriggerDemo', N'U') IS NOT NULL
BEGIN
    DROP TABLE Training.RecursiveTriggerDemo;
END;
GO

CREATE TABLE Training.RecursiveTriggerDemo
(
    DemoID INT IDENTITY(1,1) PRIMARY KEY,
    DemoValue INT NOT NULL DEFAULT 0,
    TriggerCount INT NOT NULL DEFAULT 0,
    LastModified DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE Training.RecursiveTriggerDemoLog
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    DemoID INT NOT NULL,
    TriggerInvocation INT NOT NULL,
    EventTime DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    LoginName SYSNAME NOT NULL DEFAULT SUSER_SNAME()
);
GO

CREATE OR ALTER TRIGGER Training.trg_RecursiveTriggerDemo
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
GO

DECLARE @InitialRecursiveState INT;
DECLARE @DemoID INT;

SELECT @InitialRecursiveState = CAST(DATABASEPROPERTYEX(DB_NAME(), N'IsRecursiveTriggersEnabled') AS INT);

PRINT N'Recursive triggers before demo: ' + CASE WHEN @InitialRecursiveState = 1 THEN N'ON' ELSE N'OFF' END;

IF @InitialRecursiveState = 0
BEGIN
    ALTER DATABASE CURRENT SET RECURSIVE_TRIGGERS ON;
END;

DELETE FROM Training.RecursiveTriggerDemoLog;
DELETE FROM Training.RecursiveTriggerDemo;

INSERT INTO Training.RecursiveTriggerDemo (DemoValue)
VALUES (100);

SELECT @DemoID = SCOPE_IDENTITY();

UPDATE Training.RecursiveTriggerDemo
SET DemoValue = 101
WHERE DemoID = @DemoID;

SELECT
    DemoID,
    DemoValue,
    TriggerCount,
    LastModified
FROM Training.RecursiveTriggerDemo
WHERE DemoID = @DemoID;

SELECT
    DemoID,
    TriggerInvocation,
    EventTime,
    LoginName
FROM Training.RecursiveTriggerDemoLog
WHERE DemoID = @DemoID
ORDER BY EventID;

PRINT N'Observation: if recursive triggers are enabled, the trigger should appear twice in the log.';

IF @InitialRecursiveState = 0
BEGIN
    ALTER DATABASE CURRENT SET RECURSIVE_TRIGGERS OFF;
END;
GO
