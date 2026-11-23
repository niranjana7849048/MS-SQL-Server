# Trigger Limits – Bank Account Balance Guard

## 1. Nested Triggers

A nested trigger occurs when one trigger performs an operation that activates another trigger.

**Example:**
- An UPDATE trigger on `accounts` updates an audit table.
- If the audit table also has an UPDATE trigger, that trigger may execute as well.
- This creates a chain of trigger executions.

## 2. Recursive Triggers

Recursive triggers occur when a trigger directly or indirectly causes itself to execute again.

**Example:**
- An UPDATE trigger modifies the same table.
- That modification activates the same trigger again.
- Repeated execution may cause an infinite loop or reach SQL Server's nesting limit.

## 3. How to Prevent Trigger Loops

- Avoid unnecessary updates inside triggers.
- Check whether relevant values actually changed before executing trigger logic.
- Use `TRIGGER_NESTLEVEL()` to detect excessive nesting.
- Keep trigger logic simple and avoid circular dependencies.
- Disable recursive triggers when they are not required.

Example:

```sql
IF TRIGGER_NESTLEVEL() > 1
    RETURN;
```

To disable recursive triggers at the database level:

```sql
ALTER DATABASE BankBalanceGuardDB
SET RECURSIVE_TRIGGERS OFF;
```

Note: This setting controls direct recursive triggers; it does not disable all nested trigger execution.

## 4. Limitations of Triggers

| Limitation | Explanation |
|---|---|
| Performance overhead | Triggers add processing to database operations. |
| Hidden execution | Developers may not know that triggers are running. |
| Debugging difficulty | Errors can originate from indirect trigger execution. |
| Cascading execution | One trigger can activate other triggers. |
| Maintenance complexity | Changes to trigger logic can affect multiple operations. |

## 5. When Application Logic Is Better

Application code is preferable when banking operations require complex workflows such as fraud checks, customer notifications, external payment verification, or approval processes.

Application services can coordinate these operations and return clear responses to users.

## Conclusion

Triggers provide automatic auditing and database-level validation. However, nested execution, recursion, performance overhead, and debugging complexity must be controlled carefully. Simple database rules belong in constraints where possible, while complex workflows are better handled by application services.