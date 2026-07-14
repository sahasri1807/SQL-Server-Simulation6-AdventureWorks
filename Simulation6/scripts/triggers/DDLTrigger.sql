-- ============================================================================
-- Owner: Joshua (Task 4 - trg_Database_SchemaAudit)
-- ============================================================================
-- Purpose:
-- Audits CREATE_TABLE, ALTER_TABLE, and DROP_TABLE events
-- ============================================================================

USE AdventureWorks2022;
GO

DROP TRIGGER IF EXISTS trg_Database_SchemaAudit
ON DATABASE;
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


PRINT 'trg_Database_SchemaAudit created successfully.';
GO



SELECT *
FROM Training.DatabaseSchemaAudit
ORDER BY AuditID DESC;
GO