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

A recursive trigger demonstration was developed to evaluate SQL Server recursive trigger behaviour.

The demonstration documents:

- Trigger execution sequence
- Observed behaviour
- Possible risks
- Production recommendations

The objective was to understand how recursive trigger execution can affect:

- Performance
- Data integrity
- Transaction behaviour

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
│       └── validate.sql
├── Screenshots/
│   └── .gitkeep
└── README.md
```

---

## Screenshot Checklist (15 files)

Place all screenshots in `Screenshots/`. Use the filenames below (or equivalent numbering).

| # | Filename (suggested) | Description |
|---|----------------------|-------------|
| 1 | `01_team_info.png` | Team / student information |
| 2 | `02_audit_schema.png` | Audit schema created |
| 3 | `03_product_price_audit_table.png` | `ProductPriceAudit` table |
| 4 | `04_product_deletion_audit_table.png` | `ProductDeletionAudit` table |
| 5 | `05_database_schema_audit_table.png` | `DatabaseSchemaAudit` table |
| 6 | `06_after_update_trigger.png` | After UPDATE trigger (`trg_Product_PriceAudit`) |
| 7 | `07_price_audit_test.png` | Price change audit test results |
| 8 | `08_instead_of_delete_trigger.png` | INSTEAD OF DELETE trigger |
| 9 | `09_delete_prevention_test.png` | Delete prevention test |
| 10 | `10_ddl_trigger.png` | DDL schema audit trigger |
| 11 | `11_ddl_audit_test.png` | DDL audit test results |
| 12 | `12_recursive_trigger_demo.png` | Recursive trigger demonstration |
| 13 | `13_audit_reports.png` | Audit report query output |
| 14 | `14_deploy_all.png` | Deployment script execution |
| 15 | `15_validation.png` | Validation script results |

---

## Notes

- SQL scripts currently contain **comment headers only**; each owner implements their task in the assigned file.
- Run `scripts/deployment/deploy_all.sql` and Validate `scripts/deployment/deploy_all.sql`
