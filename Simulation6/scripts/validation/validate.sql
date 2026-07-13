-- ============================================================================
-- Owner: Sahasri (validation)
-- ============================================================================
-- Task: Validation script to verify Simulation6 deployment.
-- Implementation: This script validates the recursive trigger demo objects.
-- ============================================================================

USE AdventureWorks2022;
GO

IF OBJECT_ID(N'Training.RecursiveTriggerDemo', N'U') IS NULL
BEGIN
    THROW 50001, N'Recursive trigger demo table is missing.', 1;
END;

IF OBJECT_ID(N'Training.RecursiveTriggerDemoLog', N'U') IS NULL
BEGIN
    THROW 50002, N'Recursive trigger demo log table is missing.', 1;
END;

IF OBJECT_ID(N'Training.trg_RecursiveTriggerDemo', N'TR') IS NULL
BEGIN
    THROW 50003, N'Recursive trigger demo trigger is missing.', 1;
END;

PRINT N'Validation passed: recursive trigger demo objects exist.';
GO
