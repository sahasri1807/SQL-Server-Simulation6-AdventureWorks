-- ============================================================================
-- Owner: Sahasri (validation)
-- ============================================================================
-- Task: Validation script to verify Simulation6 deployment.
-- ============================================================================

USE AdventureWorks2022;
GO


-- Check audit tables

IF OBJECT_ID(N'Training.ProductPriceAudit', N'U') IS NULL
BEGIN
    THROW 50001, N'ProductPriceAudit table is missing.', 1;
END;


IF OBJECT_ID(N'Training.ProductDeletionAudit', N'U') IS NULL
BEGIN
    THROW 50002, N'ProductDeletionAudit table is missing.', 1;
END;


IF OBJECT_ID(N'Training.DatabaseSchemaAudit', N'U') IS NULL
BEGIN
    THROW 50003, N'DatabaseSchemaAudit table is missing.', 1;
END;



-- Check DML triggers

IF OBJECT_ID(N'Production.trg_Product_PriceAudit', N'TR') IS NULL
BEGIN
    THROW 50004, N'Product price audit trigger is missing.', 1;
END;


IF OBJECT_ID(N'Production.trg_Product_PreventDelete', N'TR') IS NULL
BEGIN
    THROW 50005, N'Product delete prevention trigger is missing.', 1;
END;



-- Check database DDL trigger

IF NOT EXISTS
(
    SELECT 1
    FROM sys.triggers
    WHERE name = 'trg_Database_SchemaAudit'
)
BEGIN
    THROW 50006, N'Database schema audit trigger is missing.', 1;
END;



-- Check recursive trigger demo

IF OBJECT_ID(N'Training.RecursiveTriggerDemo', N'U') IS NULL
BEGIN
    THROW 50007, N'Recursive trigger demo table is missing.', 1;
END;


IF OBJECT_ID(N'Training.RecursiveTriggerDemoLog', N'U') IS NULL
BEGIN
    THROW 50008, N'Recursive trigger demo log table is missing.', 1;
END;


IF OBJECT_ID(N'Training.trg_RecursiveTriggerDemo', N'TR') IS NULL
BEGIN
    THROW 50009, N'Recursive trigger demo trigger is missing.', 1;
END;


PRINT N'Validation passed: Simulation6 deployment completed successfully.';
GO