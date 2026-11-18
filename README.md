# Hexaware Training Assignments – Day 5 and Day 6

## Project Overview

This repository contains the database assignments completed as part of Hexaware training.

The assignments cover relational database design, data integrity, SQL operations, MongoDB document management, SQL reporting, aggregate functions, grouping, joins and MongoDB aggregation pipelines.

The work is divided into two major sections:

- **Day 5:** Database Design, Data Integrity and MongoDB Operations
- **Day 6:** Functions, Aggregation, Grouping and Joins

## Technologies Used

- Microsoft SQL Server 2025
- MongoDB 8.0
- MongoDB Shell (mongosh)
- Visual Studio Code
- SQL
- JavaScript
- Markdown

---

# Day 5 – Database Design and MongoDB Operations

## Overview

Day 5 focuses on relational database design, normalization, constraints, data integrity, SQL table operations and MongoDB document management.

### Set 1 – Retail Inventory and Product Reviews

**Folder:** `Day5_Set1_RetailInventory`

**Business Scenario:** A retail company manages suppliers, product categories, warehouses, products and customer reviews.

**SQL Implementation:**
- Created tables for Suppliers, Categories, Warehouses and Products.
- Established primary keys and foreign key relationships.
- Applied constraints to maintain data integrity.
- Inserted sample records.
- Tested invalid inserts, updates and deletes.

**MongoDB Implementation:**
- Created a reviews collection.
- Applied schema validation.
- Inserted, updated and deleted review documents.
- Verified document counts.

**Files:**
- `schema.sql`
- `seed_data.sql`
- `collections.js`
- `ER_Diagram.md`
- `comparison.md`

### Set 2 – Bank Branch Accounts and Customer Activity

**Folder:** `Day5_Set2_BankAccounts`

**Business Scenario:** A bank manages customers, branches, relationship managers, accounts and customer activity logs.

**SQL Implementation:**
- Created Customers, Branches, RelationshipManagers, Accounts and AccountHolders tables.
- Established primary key and foreign key relationships.
- Inserted sample records.
- Demonstrated DELETE, TRUNCATE and DROP operations.
- Tested transaction rollback and identity behaviour.
- Performed account-related insert, update and query operations.

**MongoDB Implementation:**
- Created a capped activity log collection.
- Inserted customer activity records.
- Created indexes.
- Retrieved recent customer login events.

**Files:**
- `schema.sql`
- `seed_data.sql`
- `collections.js`
- `ER_Diagram.md`
- `MongoDB_Activity_Log_Justification.md`
- `identity_operations_test.sql`
- `account_operations.sql`

### Set 3 – Hospital Patient Records and Clinical Notes

**Folder:** `Day5_Set3_HospitalRecords`

**Business Scenario:** A hospital manages patient information, departments, doctors, visits and billing records.

**SQL Implementation:**
- Created Patients, Departments, Doctors, Visits and Billing tables.
- Established relational constraints.
- Inserted sample records.
- Performed ALTER TABLE operations.
- Renamed and modified database objects.
- Executed insert, update and delete operations.
- Generated reports based on visit months and doctor departments.

**MongoDB Implementation:**
- Created a clinicalNotes collection.
- Applied schema validation.
- Inserted clinical notes containing symptoms, vitals and treatment plans.
- Verified the total document count.

**Files:**
- `schema.sql`
- `seed_data.sql`
- `collections.js`
- `ER_Diagram.md`
- `alter_operations.sql`
- `patient_operations.sql`

---

# Day 6 – Functions, Aggregation, Grouping and Joins

## Overview

Day 6 focuses on generating business reports using SQL Server and MongoDB.

The assignments demonstrate aggregate functions, GROUP BY, HAVING, joins, date and string functions, NULL handling and MongoDB aggregation pipelines.

### Set 1 – Retail Sales Reporting

**Folder:** `Day6_Set1_RetailSales`

**Business Scenario:** A retail company analyzes sales, products, customers, orders and payment information.

**SQL Reports:**
1. Top five products by revenue.
2. Month-wise sales.
3. Customers with more than three orders.
4. Average basket value by city.
5. Orders without successful payment.
6. Customers without orders.
7. Revenue share by product category.
8. Highest sales day.

**MongoDB Aggregation:**
- Month-wise sales.
- Top products by revenue.
- Average basket value by city.

**Files:**
- `reports.sql`
- `reports.js`
- `Expected_Results.md`

### Set 2 – Insurance Policy Reporting

**Folder:** `Day6_Set2_InsuranceReporting`

**Business Scenario:** An insurance company analyzes customers, agents, insurance products, policies, premium payments and claims.

**SQL Reports:**
1. Policies expiring within the next 30 days.
2. Premium collected per product.
3. Customers with more than one active policy.
4. Claim ratio per product.
5. Policies without claims.
6. Average premium by customer age band.
7. Monthly new policies.
8. Top five agents by premium collected.

**MongoDB Aggregation:**
- Claims grouped by status.
- Average claim settlement time.
- Top three damage categories.

**Files:**
- `reports.sql`
- `reports.js`
- `Expected_Results.md`

### Set 3 – Telecom Usage and Billing Reporting

**Folder:** `Day6_Set3_TelecomReporting`

**Business Scenario:** A telecom company analyzes subscriber information, plans, usage records, invoices and network activity.

**SQL Reports:**
1. Total call minutes per plan.
2. Subscribers exceeding their monthly data limit.
3. Month-wise revenue.
4. Invoices overdue by more than 15 days.
5. Subscribers without usage records.
6. Average Revenue Per User (ARPU) by circle.
7. Plan popularity.
8. Top ten data consumers.

**MongoDB Aggregation:**
- Hourly usage analysis.
- Average session length.
- Busiest cell towers.

**Files:**
- `reports.sql`
- `reports.js`
- `Expected_Results.md`
- `README.md`

---

# Key Concepts Covered

## SQL Server

| Category | Concepts |
|---|---|
| Database Design | CREATE DATABASE, CREATE TABLE |
| Data Manipulation | INSERT, UPDATE, DELETE |
| Data Definition | ALTER, DROP, TRUNCATE |
| Constraints | PRIMARY KEY, FOREIGN KEY, CHECK, UNIQUE, NOT NULL |
| Relationships | One-to-One, One-to-Many, Many-to-Many |
| Joins | INNER JOIN, LEFT JOIN |
| Aggregation | SUM(), AVG(), COUNT(), MIN(), MAX() |
| Grouping | GROUP BY, HAVING |
| Date Functions | GETDATE(), DATEADD(), DATEDIFF(), FORMAT() |
| String Functions | UPPER(), CONCAT(), LEFT(), RIGHT() |
| Conditional Logic | CASE |
| Transactions | COMMIT, ROLLBACK |
| NULL Handling | IS NULL, IS NOT NULL, aggregate behaviour |

## MongoDB

| Category | Concepts |
|---|---|
| Database Operations | Database and collection creation |
| Document Operations | insertOne(), insertMany(), find(), updateOne(), deleteOne() |
| Validation | JSON Schema validation |
| Indexing | Creating and using indexes |
| Capped Collections | Activity log management |
| Aggregation | aggregate() |
| Pipeline Stages | $match, $group, $sort, $limit, $project |
| Accumulators | $sum, $avg |
| Date Processing | $hour and date calculations |
| Data Relationships | $lookup and $unwind |

---

# Tools and Execution

## SQL Server Execution

1. Open Visual Studio Code.
2. Connect to the SQL Server instance using the SQL Server extension.
3. Open the required `.sql` file.
4. Execute the script.
5. Verify the created database, tables, records and report outputs.

## MongoDB Execution

1. Ensure MongoDB Community Server is running.
2. Open the VS Code terminal.
3. Navigate to the required assignment folder.
4. Execute the JavaScript file using MongoDB Shell.

Example:

```powershell
mongosh --file .\collections.js
```

For Day 6:

```powershell
mongosh --file .\reports.js
```

---

# Learning Outcomes

Through these assignments, the following skills were practiced:

- Designing relational databases for different business scenarios.
- Establishing relationships between database tables.
- Maintaining data integrity using constraints.
- Performing SQL data definition and manipulation operations.
- Understanding transactions and rollback behaviour.
- Managing MongoDB collections and documents.
- Applying schema validation and indexes.
- Writing SQL queries using joins and aggregate functions.
- Generating business reports using GROUP BY and HAVING.
- Handling NULL values in aggregate calculations.
- Using SQL date, string and conditional functions.
- Creating MongoDB aggregation pipelines.
- Comparing relational and document-oriented database approaches.

---

# Conclusion

Day 5 and Day 6 assignments provide practical experience in SQL Server and MongoDB through retail, banking, healthcare, insurance and telecom business scenarios.

Day 5 emphasizes database structure, relationships, constraints and document operations.

Day 6 builds on those concepts by applying SQL reporting, aggregation, grouping, joins and MongoDB aggregation pipelines to business data.

Together, these assignments demonstrate practical database development and reporting skills using SQL Server 2025 and MongoDB 8.0.
