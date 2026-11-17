# SQL Server vs MongoDB – Comparison

| Operation                   | SQL Server                    | MongoDB                                           |
| --------------------------- | ----------------------------- | ------------------------------------------------- |
| Database creation           | `CREATE DATABASE`             | `use()`                                           |
| Table / Collection creation | `CREATE TABLE`                | `db.createCollection()`                           |
| Insert records              | `INSERT INTO`                 | `insertMany()`                                    |
| Retrieve records            | `SELECT`                      | `find()`                                          |
| Update records              | `UPDATE`                      | `updateOne()`                                     |
| Delete records              | `DELETE`                      | `deleteOne()`                                     |
| Data structure              | Tables and rows               | Collections and documents                         |
| Schema                      | Fixed relational schema       | Flexible document schema with optional validation |
| Relationships               | Primary keys and foreign keys | References or embedded documents                  |

## MongoDB Data Storage Decisions

1. **Product Reviews:** Store reviews in MongoDB because review text is free-form and may contain varying information.
2. **Search Activity:** Store search activity in MongoDB because search queries and filter combinations can vary between users.

## Conclusion

SQL Server is suitable for structured inventory data that requires relationships and constraints. MongoDB is suitable for flexible, document-based data such as product reviews and search activity.
