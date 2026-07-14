# Task 5 - Recursive Trigger Demonstration (Dhruv)

## What we did
We created a small SQL Server demo to show how recursive triggers behave in the AdventureWorks2022 database.

The task involved:
- creating a demo table to hold sample trigger data
- creating a log table to record trigger activity
- creating an AFTER UPDATE trigger that updates the same table
- running a demo scenario to observe the trigger behavior
- validating the result using a testing guide

## Why this was done
Recursive triggers can cause repeated execution, which may lead to performance issues, unexpected updates, and possible nesting problems. This demo was created to understand and demonstrate that behavior in a controlled environment.

## Files used
- Simulation6/scripts/demo/RecursiveTriggerDemo.sql
  - Main script for creating the objects and running the demo
- Simulation6/scripts/deployment/deploy_all.sql
  - Deployment file that includes the Task 5 setup section
- Simulation6/scripts/validation/Dhruv_RecursiveTrigger_Testing.sql
  - Testing guide used to validate the result

## How it works
1. The demo tables are created in the Training schema.
2. An AFTER UPDATE trigger is created on the demo table.
3. When an update occurs, the trigger inserts an event into the log table and updates the main demo row.
4. The demo script then displays the final values from the table and the log entries.
5. The testing guide helps confirm that the objects exist and the trigger behavior is captured correctly.

## Result observed
The demo successfully showed:
- the trigger was created
- the update operation completed
- trigger activity was logged
- the demo row was updated with the new values

## Summary
This Task 5 work demonstrates how recursive trigger behavior can be tested and observed in SQL Server using a simple, controlled example. It also shows how deployment and validation scripts support the complete assignment workflow.
