# Written Justification – Hospital Bed Capacity Control

## 1. Why Use a Trigger?

A trigger is useful when admission rules must be enforced automatically whenever records are inserted, regardless of which application or user performs the operation.

The admission trigger checks the ward's existing admissions and available capacity before allowing new admissions.

If the capacity is exceeded, it raises an error using `THROW` and rejects the entire insert statement.

## 2. When Is a Constraint Better?

A constraint is better for simple rules involving individual rows or columns.

**Example:**

```sql
CHECK (bed_capacity >= 0)
```

This ensures that ward capacity cannot be negative.

Constraints are:
- Easier to understand and maintain.
- Automatically enforced by SQL Server.
- Generally more efficient for simple validation rules.

However, a CHECK constraint cannot directly enforce a rule that compares the number of admission records with another table's bed capacity.

## 3. When Is a Stored Procedure Better?

A stored procedure is preferable when admission requires multiple coordinated operations.

For example:
1. Check ward availability.
2. Verify patient details.
3. Reserve a bed.
4. Insert the admission record.
5. Update occupied bed count.
6. Commit the transaction.

A stored procedure can manage these steps within a transaction and return meaningful results to the application.

## 4. Comparison

| Approach | Best Use |
|---|---|
| Constraint | Simple validation rules |
| Trigger | Automatic enforcement and auditing of database changes |
| Stored Procedure | Multi-step business workflows and transaction management |

## 5. MongoDB Change Streams

MongoDB Change Streams allow applications to listen for database changes.

In this assignment, the change stream monitors the `ward_alerts` collection and reacts only when a new document with `severity: "critical"` is inserted.

Change Streams require a replica set or sharded cluster.

Unlike SQL Server triggers, Change Streams observe database events through an application listener and do not directly block database operations.

## Conclusion

Triggers are suitable for automatic admission validation and audit logging. Constraints are better for simple data validation, while stored procedures are more appropriate for complex admission workflows involving multiple operations and transaction management.