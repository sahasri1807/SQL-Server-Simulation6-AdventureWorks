-- ============================================================================
-- Owner: Sahasri (deployment)
-- ============================================================================
-- Task: Master deployment script for all Simulation6 objects.
-- Implementation: This script runs the project scripts in order.
-- ============================================================================

:r ..\setup\CreateAuditEnvironment.sql
:r ..\triggers\AfterUpdateTrigger.sql
:r ..\triggers\InsteadOfDeleteTrigger.sql
:r ..\triggers\DDLTrigger.sql
:r ..\demo\RecursiveTriggerDemo.sql
:r ..\reports\AuditReports.sql
