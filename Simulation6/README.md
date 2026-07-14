# Enterprise Trigger Development and Database Auditing

## SQL Server Development – Simulation 6

---

# Project Information

| Item | Details |
|---|---|
| Course | SQL Server Development |
| Module | SQL Server Triggers and Database Auditing |
| Lab Number | Simulation 6 |
| Lab Title | Enterprise Trigger Development and Database Auditing |
| Business Organization | TD Bank Group (Educational Scenario) |
| Database Platform | Microsoft SQL Server 2022 |
| Implementation Database | AdventureWorks2022 |
| Schema Created | Training |
| Development Environment | SQL Server Management Studio (SSMS) |
| Team Size | 9 Members |
| Project Duration | 7 Days |

---

# Project Overview

The **Enterprise Trigger Development and Database Auditing** project implements an automated auditing framework using SQL Server triggers within the AdventureWorks2022 database.

The purpose of this project is to demonstrate how enterprise database systems can monitor critical business activities, enforce data integrity rules, maintain historical records, and support compliance investigations.

A dedicated **Training** schema was created to separate audit information from operational business data.

The implemented solution includes:

- Audit environment creation
- Product price history tracking
- Product deletion protection
- Database schema change auditing
- Recursive trigger behaviour evaluation
- Compliance reporting

This project represents an educational implementation of a database auditing solution similar to those used in enterprise financial environments.

---

# Business Scenario

TD Bank Group requires stronger database governance controls to support:

- Regulatory compliance
- Historical investigation
- Data integrity
- Operational accountability
- Security monitoring

The solution addresses the following business risks:

| Risk | Solution Implemented |
|---|---|
| Product prices modified without history | AFTER UPDATE trigger auditing |
| Products deleted despite transaction history | INSTEAD OF DELETE trigger protection |
| Database changes not monitored | DDL trigger auditing |
| Recursive trigger risks unknown | Recursive trigger demonstration |
| Audit information unavailable | Compliance reporting queries |

---

# Team Members and Responsibilities

The project work was divided among nine team members. Each member was assigned ownership of specific database components to ensure clear responsibility, efficient development, and proper integration.

| Member | Role | Responsibility |
|---|---|---|
| Sahasri | Team Lead / Project Coordinator | Final integration, documentation, QA review, GitHub submission |
| Hassana | Audit Environment Developer | Training schema and ProductPriceAudit development |
| Brian | AFTER Trigger Developer | Product price auditing trigger implementation |
| Parth | INSTEAD OF Trigger Developer | Product deletion prevention trigger |
| Joshua | DDL Trigger Developer | Database schema auditing trigger |
| Kelvin | Audit Table Developer | ProductDeletionAudit and DatabaseSchemaAudit implementation |
| Lien | Reporting Developer | Product audit and deletion compliance reports |
| Sahil | Reporting & Validation Developer | Schema reports, login activity reports, testing support |
| Dhruv | Recursive Trigger Developer | Recursive trigger demonstration  |

---

# Task Division and Team Contribution

The project tasks were distributed based on database layers and technical responsibilities.

| Member | Assigned Task | Deliverables |
|---|---|---|
| Sahasri | Final Integration and Submission | Complete project integration, documentation, README, screenshot compilation, QA review, GitHub submission |
| Hassana | Task 1 - Audit Environment | Training schema creation, ProductPriceAudit table, constraints, indexes |
| Brian | Task 2 - AFTER UPDATE Trigger | trg_Product_PriceAudit trigger, price change auditing logic |
| Parth | Task 3 - INSTEAD OF DELETE Trigger | trg_Product_PreventDelete trigger, deletion validation and auditing |
| Joshua | Task 4 - Database DDL Trigger | trg_Database_SchemaAudit trigger, CREATE/ALTER/DROP auditing |
| Kelvin | Audit Table Development | ProductDeletionAudit table, DatabaseSchemaAudit table |
| Dhruv | Task 5 - Recursive Trigger Demonstration | Recursive trigger testing, execution sequence analysis, documentation |
| Lien | Task 6 Part A - Compliance Reporting | Product price audit report, deletion attempt report |
| Sahil | Task 6 Part B - Compliance Reporting | Schema modification report, login activity report, daily audit summary |

---

# Implemented Database Components

## 1. Training Schema

A dedicated schema named **Training** was created to store all audit-related objects.

Purpose:

- Separate audit data from operational data
- Improve maintainability
- Protect historical records
- Support compliance reporting

---

# Audit Tables

## ProductPriceAudit

Purpose:

Stores historical product price modifications.

Captured information:

- Product ID
- Product Name
- Previous Price
- Updated Price
- User responsible for modification
- Change timestamp


## ProductDeletionAudit

Purpose:

Stores rejected product deletion attempts.

Captured information:

- Product ID
- Product Name
- Attempting user
- Attempt timestamp
- Reason for rejection


## DatabaseSchemaAudit

Purpose:

Stores database structure modification events.

Captured information:

- Event type
- Object name
- SQL Server login
- Event timestamp

---

# Trigger Implementation

## AFTER UPDATE Trigger

### Trigger Name

`trg_Product_PriceAudit`

### Purpose

Automatically records successful product price changes.

### Features

- Executes after updates on Production.Product
- Detects ListPrice modifications
- Stores old and new values
- Captures SQL Server login
- Supports multiple row updates
- Ignores non-price changes


---

## INSTEAD OF DELETE Trigger

### Trigger Name

`trg_Product_PreventDelete`

### Purpose

Prevents deletion of products that are referenced by customer transactions.

### Features

- Checks Sales.SalesOrderDetail references
- Blocks invalid deletions
- Records rejected attempts
- Allows deletion of unused products


---

## Database DDL Trigger

### Trigger Name

`trg_Database_SchemaAudit`

### Purpose

Audits database structure changes.

### Monitored Events

- CREATE TABLE
- ALTER TABLE
- DROP TABLE

### Captured Information

- Event type
- Object name
- Login name
- Date and time

---

# Recursive Trigger Demonstration

A recursive trigger demonstration was developed to evaluate SQL Server recursive trigger behaviour for Task 5.

### Implementation Summary

The Task 5 solution includes the following files:

- `Simulation6/scripts/demo/RecursiveTriggerDemo.sql` — creates the demo tables, trigger, and executes the recursive trigger scenario.
- `Simulation6/scripts/deployment/deploy_all.sql` — includes the Task 5 deployment section so the demo objects are created in the project environment.
- `Simulation6/scripts/validation/Dhruv_RecursiveTrigger_Testing.sql` — provides a step-by-step validation guide for Dhruv's assignment.

### What the Demo Demonstrates

The script shows how an AFTER UPDATE trigger can update the same table and log repeated trigger activity. The demonstration helps explain:

- Trigger execution sequence
- Recursive trigger behaviour
- Potential nesting risks
- Safe testing and validation approach

### Expected Outcome

When the demo is executed successfully, the system should:

- create the recursive trigger demo objects in the Training schema
- insert a demo row into the main demo table
- record trigger activity in the log table
- display the updated values for `DemoValue`, `TriggerCount`, and `LastModified`

---

# Compliance Reports

The reporting module provides audit information required for compliance investigations.

Implemented reports:

## 1. Product Price Audit History

Displays:

- Product changes
- Previous prices
- Updated prices
- Users responsible
- Change timestamps


## 2. Prevented Deletion Attempts

Displays:

- Products that could not be deleted
- Reason for rejection
- Attempting users
- Attempt timestamps


## 3. Database Schema Modification History

Displays:

- CREATE TABLE events
- ALTER TABLE events
- DROP TABLE events


## 4. Audit Activity by Login

Displays:

- User activity
- Number of audit actions
- Activity summary


## 5. Daily Audit Activity Summary

Displays:

- Daily number of audit events
- Audit trends

---

# Repository Structure


## Repository Structure

```
Simulation6/
├── scripts/
│   ├── setup/
│   │   └── CreateAuditEnvironment.sql
│   ├── triggers/
│   │   ├── AfterUpdateTrigger.sql
│   │   ├── InsteadOfDeleteTrigger.sql
│   │   └── DDLTrigger.sql
│   ├── demo/
│   │   └── RecursiveTriggerDemo.sql
│   ├── reports/
│   │   └── AuditReports.sql
│   ├── deployment/
│   │   └── deploy_all.sql
│   └── validation/
│       ├── Dhruv_RecursiveTrigger_Testing.sql
│       └── validate.sql
├── Screenshots/
│   ├── task_5_dhruv_deplyment.png
│   ├── task_5_dhruv_testing.png
│   └── task_5_dhruv_trigger-demo.png
└── README.md
```

---

## Screenshot Checklist

Place screenshots in `Screenshots/` and use the names below for consistency.

| # | Filename | Description |
|---|----------|-------------|
| 1 | `task_5_dhruv_deplyment.png` | Deployment script execution for Task 5 |
| 2 | `task_5_dhruv_trigger-demo.png` | Recursive trigger demo output |
| 3 | `task_5_dhruv_testing.png` | Validation/testing results for Task 5 |

---

## Notes

- Run `scripts/deployment/deploy_all.sql` first to create the required objects.
- Then run `scripts/demo/RecursiveTriggerDemo.sql` to execute the Task 5 recursive trigger demonstration.
- Use `scripts/validation/Dhruv_RecursiveTrigger_Testing.sql` to confirm the expected results.
