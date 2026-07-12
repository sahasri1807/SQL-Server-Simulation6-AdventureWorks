-- ============================================================================
-- Owner: Joshua (Task 4 - trg_Database_SchemaAudit)
-- ============================================================================
-- Purpose:
-- Audits CREATE TABLE, ALTER TABLE, and DROP TABLE events occurring in
-- the AdventureWorks2022 database.
-- ============================================================================

USE AdventureWorks2022;
GO

SET ANSI_NULLS ON;
GO

SET QUOTED_IDENTIFIER ON;
GO

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
        EventDate
    )
    VALUES
    (
        @EventData.value(
            '(/EVENT_INSTANCE/EventType)[1]',
            'NVARCHAR(50)'
        ),
        @EventData.value(
            '(/EVENT_INSTANCE/ObjectName)[1]',
            'NVARCHAR(128)'
        ),
        SUSER_SNAME(),
        SYSUTCDATETIME()
    );
END;
GO

PRINT 'trg_Database_SchemaAudit created successfully.';
GO
