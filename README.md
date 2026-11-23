# Assignments – Days 5, 6, 7, 8, 9 & 10

## Overview

This repository contains SQL Server and MongoDB assignments completed as part of Hexaware training. It covers database design, SQL querying, data manipulation, transactions, advanced SQL concepts, and database automation through triggers and change streams.

## Days Covered

- **Day 5 – Database Design and Operations:** Retail Inventory, Bank Accounts, and Hospital Records.
- **Day 6 – Functions, Aggregation, Grouping and Joins:** Retail Sales, Insurance Reporting, and Telecom Reporting.
- **Day 7 – Joins, Subqueries and Lookups:** Logistics Shipments, Bank Loans, and Retail Returns.
- **Day 8 – Transactions, CTEs and Window Functions:** Bank Funds Transfer, Airline Seat Booking, and Retail Inventory Reservation.
- **Day 9 – Views, Stored Procedures, Functions and Cursors:** Retail Order Fulfilment and related database operations.
- **Day 10 – Triggers and Change Detection:** Retail Price Change Audit, Bank Account Balance Guard, and Hospital Bed Capacity Control.

## Technologies Used

- SQL Server 2025
- MongoDB 8.0
- MongoDB Shell (mongosh)
- JavaScript (Node.js)
- T-SQL

## Topics Covered

- Database creation and data manipulation
- SQL constraints and relationships
- Aggregate functions and grouping
- Joins and subqueries
- MongoDB CRUD operations
- Aggregation pipelines and `$lookup`
- Transactions, COMMIT and ROLLBACK
- Transaction isolation and ACID properties
- CTEs and window functions
- MongoDB transactions and atomic updates
- Views, stored procedures and user-defined functions
- SQL cursors and MongoDB views
- AFTER and INSTEAD OF triggers
- `inserted` and `deleted` tables
- Multi-row trigger processing and audit logging
- Trigger recursion and nested triggers
- MongoDB Change Streams
- Replica sets and real-time change monitoring

## Execution

Run `.sql` files in SQL Server Management Studio or a compatible SQL Server query editor.

Run MongoDB JavaScript files using:

```powershell
mongosh --file .\reports.js
```

For Node.js MongoDB Change Stream scripts, install the MongoDB driver:

```powershell
npm install mongodb
```

Then execute:

```powershell
node watch_changes.js
```

**Note:** MongoDB Change Streams require a replica set or sharded cluster.

## Conclusion

These assignments provide practical experience in SQL Server database development and MongoDB operations, covering foundational database concepts through advanced querying, transaction management, auditing, and real-time change monitoring.
