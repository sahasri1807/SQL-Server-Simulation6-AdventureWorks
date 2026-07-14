-- ============================================================================
-- Dhruv - Recursive Trigger Demo Testing Guide
-- ============================================================================
-- Purpose:
-- This file explains how to test the recursive trigger demo that was assigned
-- to Dhruv for Task 5: Recursive Trigger Demonstration.
--
-- How this connects to your assignment:
-- - The demo script creates the objects needed for the task.
-- - The deployment script brings those objects into the project environment.
-- - The validation script confirms that the objects exist.
-- - This testing file shows you how to verify that the trigger behaves as expected.
-- ============================================================================

-- Step 1: Connect to the correct database
USE AdventureWorks2022;
GO

-- Step 2: Check whether the Training schema exists
SELECT name
FROM sys.schemas
WHERE name = 'Training';
GO

-- Step 3: Run the deployment script
-- This connects to your assignment because it loads the full project setup,
-- including the recursive trigger demo objects.
-- Open and execute: scripts/deployment/deploy_all.sql

-- Step 4: Verify that the demo objects exist
-- These are the objects created for your assigned task.
SELECT
    name,
    type_desc
FROM sys.objects
WHERE schema_id = SCHEMA_ID('Training')
  AND name IN ('RecursiveTriggerDemo', 'RecursiveTriggerDemoLog', 'trg_RecursiveTriggerDemo');
GO

-- Step 5: Confirm that the trigger is present
-- This directly verifies the trigger created for Task 5.
SELECT
    name,
    type_desc
FROM sys.objects
WHERE name = 'trg_RecursiveTriggerDemo';
GO

-- Step 6: Run the recursive trigger demo script
-- This is the main part of your assignment.
-- Open and execute: scripts/demo/RecursiveTriggerDemo.sql

-- Step 7: Review the updated demo table
-- This shows whether the update operation completed and whether the trigger
-- affected the row in the demo table.
SELECT *
FROM Training.RecursiveTriggerDemo;
GO

-- Step 8: Review the trigger execution log
-- This proves whether the trigger fired and logged its activity.
SELECT *
FROM Training.RecursiveTriggerDemoLog
ORDER BY EventID;
GO

-- Step 9: Check the expected outcome for your task
-- For this assignment, successful testing means:
-- - a row exists in Training.RecursiveTriggerDemo
-- - the trigger activity is recorded in Training.RecursiveTriggerDemoLog
-- - the TriggerCount value changes as expected
SELECT
    DemoID,
    DemoValue,
    TriggerCount,
    LastModified
FROM Training.RecursiveTriggerDemo;
GO

-- Step 10: Run the validation script
-- This confirms that your task is properly integrated into the project.
-- Open and execute: scripts/validation/validate.sql

-- ============================================================================
-- Expected result:
-- If everything is working correctly, the validation script should print a
-- success message and the demo objects should be present and populated.
-- ============================================================================
