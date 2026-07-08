# Simulation 6 — AdventureWorks Audit & Triggers

**Repository:** [SQL-Server-Simulation6-AdventureWorks](https://github.com/sahasri1807/SQL-Server-Simulation6-AdventureWorks)

**Course / Section:** _[Placeholder — add course info]_  
**Team Name:** _[Placeholder]_  
**Submission Date:** _[Placeholder]_

---

## Team Assignments

| Task | Owner(s) | Script / Deliverable |
|------|----------|----------------------|
| 1A — Training schema, `ProductPriceAudit` | Hassana | `scripts/setup/CreateAuditEnvironment.sql` |
| 1B — `ProductDeletionAudit`, `DatabaseSchemaAudit` | Kelvin | `scripts/setup/CreateAuditEnvironment.sql` |
| 2 — `trg_Product_PriceAudit` | Brian | `scripts/triggers/AfterUpdateTrigger.sql` |
| 3 — `trg_Product_PreventDelete` | Parth | `scripts/triggers/InsteadOfDeleteTrigger.sql` |
| 4 — `trg_Database_SchemaAudit` | Joshua | `scripts/triggers/DDLTrigger.sql` |
| 5 — Recursive trigger demo | Dhruv | `scripts/demo/RecursiveTriggerDemo.sql` |
| 6A — Audit reports (part A) | Lien | `scripts/reports/AuditReports.sql` |
| 6B — Audit reports (part B) | Sahil | `scripts/reports/AuditReports.sql` |
| Deployment | Sahasri | `scripts/deployment/deploy_all.sql` |
| Validation | Sahasri | `scripts/validation/validate.sql` |
| Project coordination / README | Sahasri | `README.md` |

---

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

## Student Information (placeholders)

| Name | Student ID | Email |
|------|------------|-------|
| Hassana | _[ID]_ | _[email]_ |
| Kelvin | _[ID]_ | _[email]_ |
| Brian | _[ID]_ | _[email]_ |
| Parth | _[ID]_ | _[email]_ |
| Joshua | _[ID]_ | _[email]_ |
| Dhruv | _[ID]_ | _[email]_ |
| Lien | _[ID]_ | _[email]_ |
| Sahil | _[ID]_ | _[email]_ |
| Sahasri | _[ID]_ | _[email]_ |

---

## Notes

- SQL scripts currently contain **comment headers only**; each owner implements their task in the assigned file.
- Run `scripts/deployment/deploy_all.sql` after all scripts are complete, then `scripts/validation/validate.sql`.
