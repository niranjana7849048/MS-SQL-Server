# Trigger Pitfalls – Retail Price Change Audit

## 1. Risks of Using Triggers

### Risk 1: Hidden Business Logic
- Triggers execute automatically when a table operation occurs.
- Developers may not know that additional logic is running.
- This makes debugging and maintenance difficult.

### Risk 2: Cascading Trigger Execution
- One trigger may modify another table.
- That modification may activate another trigger.
- Multiple trigger executions can cause unexpected behaviour, performance issues, or recursion.

## 2. When Application Code Is Better

Application code is better when price validation requires complex business rules, such as customer-specific discounts, promotional pricing, or external approval.

The application can validate the request, provide a meaningful response to the user, and coordinate multiple operations more clearly.

## 3. Trigger vs MongoDB Change Stream

| SQL Server Trigger | MongoDB Change Stream |
|---|---|
| Executes automatically during a database operation. | Allows applications to listen for database changes. |
| Runs inside the database transaction. | Delivers change events to an external consumer. |
| Can modify or reject database operations. | Observes changes but does not directly reject them. |
| Uses `inserted` and `deleted` tables. | Uses change event documents. |

## 4. MongoDB Change Stream Requirement

MongoDB Change Streams require a replica set or sharded cluster. They cannot run on a standalone MongoDB server.

## Conclusion

Triggers are useful for automatic auditing and enforcing database-level rules. However, hidden execution, cascading behaviour, and maintenance complexity are important limitations. Complex business workflows are often better handled by application code.