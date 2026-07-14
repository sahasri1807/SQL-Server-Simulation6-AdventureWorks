-- ============================================================================
-- Owner: Lien / Sahil
-- Task 6 - Compliance Reporting
-- ============================================================================

USE AdventureWorks2022;
GO


-- ============================================================================
-- Create AuditReader Role
-- ============================================================================

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_principals
    WHERE name = 'AuditReader'
      AND type = 'R'
)
BEGIN
    CREATE ROLE AuditReader;
END;
GO


GRANT SELECT ON Training.ProductPriceAudit TO AuditReader;
GRANT SELECT ON Training.ProductDeletionAudit TO AuditReader;
GRANT SELECT ON Training.DatabaseSchemaAudit TO AuditReader;
GO



-- ============================================================================
-- Report 1: Product Price Audit History
-- ============================================================================

DECLARE @FromDate DATETIME2 = '1900-01-01';
DECLARE @ToDate DATETIME2 = SYSDATETIME();
DECLARE @MaxRows INT = 10000;


SELECT TOP (@MaxRows)
    AuditID,
    ProductID,
    OldPrice,
    NewPrice,
    NewPrice - OldPrice AS PriceDifference,
    ChangedBy,
    ChangeDate
FROM Training.ProductPriceAudit
WHERE ChangeDate >= @FromDate
AND ChangeDate <= @ToDate
ORDER BY ChangeDate DESC;

GO



-- ============================================================================
-- Report 2: Prevented Product Deletion Attempts
-- ============================================================================

DECLARE @FromDate2 DATETIME2 = '1900-01-01';
DECLARE @ToDate2 DATETIME2 = SYSDATETIME();
DECLARE @MaxRows2 INT = 10000;


SELECT TOP (@MaxRows2)
    AuditID,
    ProductID,
    ProductName,
    AttemptedBy,
    AttemptDate,
    Reason
FROM Training.ProductDeletionAudit
WHERE AttemptDate >= @FromDate2
AND AttemptDate <= @ToDate2
ORDER BY AttemptDate DESC;

GO



-- ============================================================================
-- Report 3: Schema Modification Audit Report
-- ============================================================================

SELECT
    AuditID,
    EventType,
    ObjectName,
    LoginName,
    EventDate
FROM Training.DatabaseSchemaAudit
ORDER BY EventDate DESC;

GO



-- ============================================================================
-- Report 4: Login Activity Summary
-- ============================================================================

SELECT
    LoginName,
    COUNT(*) AS TotalSchemaChanges
FROM Training.DatabaseSchemaAudit
GROUP BY LoginName
ORDER BY TotalSchemaChanges DESC;

GO



-- ============================================================================
-- Report 5: Daily Audit Summary
-- ============================================================================

SELECT
    CAST(EventDate AS DATE) AS AuditDate,
    COUNT(*) AS TotalEvents
FROM Training.DatabaseSchemaAudit
GROUP BY CAST(EventDate AS DATE)
ORDER BY AuditDate DESC;

GO