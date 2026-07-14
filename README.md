# SQL Server Simulation 6 - AdventureWorks Trigger and Auditing Lab

This repository contains the full SQL Server simulation project for Enterprise Trigger Development and Database Auditing using the AdventureWorks2022 database.

## Project Overview
This simulation demonstrates how SQL Server triggers can be used to strengthen database governance, maintain audit trails, and support compliance investigations. The project implements a practical auditing framework using:

- a dedicated Training schema for audit data
- trigger-based auditing for product price changes
- deletion protection for products with transactional references
- DDL auditing for schema changes
- a recursive trigger demonstration for Task 5
- reporting queries for audit visibility

## Simulation Goals
The project addresses common enterprise database risks such as:
- missing historical records for price changes
- uncontrolled product deletion
- untracked schema changes
- unknown recursive trigger behavior
- limited audit reporting

## Team Responsibilities
The work is divided across contributors as follows:

- Sahasri — project integration, documentation, deployment coordination, GitHub submission
- Hassana — audit environment and Training schema setup
- Brian — AFTER UPDATE trigger implementation for product price auditing
- Parth — INSTEAD OF DELETE trigger implementation for product deletion protection
- Joshua — DDL trigger implementation for schema change auditing
- Kelvin — audit tables for deletion and schema change tracking
- Lien — reporting queries for audit and compliance review
- Sahil — reporting and validation support
- Dhruv — Task 5 recursive trigger demonstration and validation

## Main Components
### 1. Audit Environment
Created in the Training schema to store audit-related objects separately from operational data.

### 2. Audit Tables
- ProductPriceAudit
- ProductDeletionAudit
- DatabaseSchemaAudit

### 3. Triggers
- trg_Product_PriceAudit
- trg_Product_PreventDelete
- trg_Database_SchemaAudit
- trg_RecursiveTriggerDemo

### 4. Reports
The project includes reporting queries for:
- product price history
- prevented deletion attempts
- schema change auditing

## Repository Structure
- [Simulation6/README.md](Simulation6/README.md) — detailed project documentation
- [Simulation6/scripts/setup/CreateAuditEnvironment.sql](Simulation6/scripts/setup/CreateAuditEnvironment.sql) — audit environment setup
- [Simulation6/scripts/triggers/AfterUpdateTrigger.sql](Simulation6/scripts/triggers/AfterUpdateTrigger.sql) — product price audit trigger
- [Simulation6/scripts/triggers/InsteadOfDeleteTrigger.sql](Simulation6/scripts/triggers/InsteadOfDeleteTrigger.sql) — deletion prevention trigger
- [Simulation6/scripts/triggers/DDLTrigger.sql](Simulation6/scripts/triggers/DDLTrigger.sql) — schema change audit trigger
- [Simulation6/scripts/demo/RecursiveTriggerDemo.sql](Simulation6/scripts/demo/RecursiveTriggerDemo.sql) — Task 5 recursive trigger demo
- [Simulation6/scripts/reports/AuditReports.sql](Simulation6/scripts/reports/AuditReports.sql) — audit reporting queries
- [Simulation6/scripts/deployment/deploy_all.sql](Simulation6/scripts/deployment/deploy_all.sql) — master deployment script
- [Simulation6/scripts/validation/validate.sql](Simulation6/scripts/validation/validate.sql) — validation script
- [Simulation6/scripts/validation/Dhruv_RecursiveTrigger_Testing.sql](Simulation6/scripts/validation/Dhruv_RecursiveTrigger_Testing.sql) — Task 5 testing guide

## How to Run
1. Run [Simulation6/scripts/deployment/deploy_all.sql](Simulation6/scripts/deployment/deploy_all.sql)
2. Run [Simulation6/scripts/demo/RecursiveTriggerDemo.sql](Simulation6/scripts/demo/RecursiveTriggerDemo.sql) for the recursive trigger demo
3. Run [Simulation6/scripts/validation/validate.sql](Simulation6/scripts/validation/validate.sql) or [Simulation6/scripts/validation/Dhruv_RecursiveTrigger_Testing.sql](Simulation6/scripts/validation/Dhruv_RecursiveTrigger_Testing.sql) for validation

## Notes for Contributors
This repository is intended as a reference for the full simulation assignment. Each contributor should keep their assigned scripts focused on their task while ensuring the deployment and validation flow remains intact.
