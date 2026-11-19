
# Day 8 – Set 1: Bank Funds Transfer

## 1. READ COMMITTED Isolation

READ COMMITTED prevents dirty reads. A transaction cannot read data modified by another uncommitted transaction.

### Two-session example

Session 1:
```sql
BEGIN TRANSACTION;

UPDATE BankAccounts
SET Balance = Balance - 1000
WHERE AccountID = 101;

WAITFOR DELAY '00:00:10';

COMMIT;
```

Session 2 (execute while Session 1 is waiting):
```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT Balance
FROM BankAccounts
WHERE AccountID = 101;
```

Session 2 normally waits for Session 1's exclusive lock to be released, then reads the committed balance.

## 2. SNAPSHOT Isolation

SNAPSHOT provides a transaction-level consistent view of committed data using row versions. Readers generally do not block writers.

Enable it once:
```sql
ALTER DATABASE BankDB
SET ALLOW_SNAPSHOT_ISOLATION ON;
```

Session 1:
```sql
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRANSACTION;

SELECT Balance
FROM BankAccounts
WHERE AccountID = 101;

WAITFOR DELAY '00:00:10';

SELECT Balance
FROM BankAccounts
WHERE AccountID = 101;

COMMIT;
```

Session 2 (execute while Session 1 is waiting):
```sql
UPDATE BankAccounts
SET Balance = Balance - 1000
WHERE AccountID = 101;
```

Session 1 continues to see the same transaction-level snapshot, even after Session 2 commits.

## 3. Comparison

| Feature | READ COMMITTED | SNAPSHOT |
|---|---|---|
| Dirty reads | Prevented | Prevented |
| Reading uncommitted data | Not allowed | Not allowed |
| Reader-writer blocking | Possible | Generally avoided |
| Consistency | Statement-level | Transaction-level |
| Implementation | Locks or row versioning, depending on configuration | Row versioning |
| Storage overhead | Depends on configuration | Uses row versions |

## 4. MongoDB Multi-document Transactions

MongoDB transactions allow multiple document operations to succeed or fail together.

For a bank transfer:
1. Start a session.
2. Begin a transaction.
3. Debit the source account.
4. Credit the destination account.
5. Commit if both operations succeed.
6. Abort if an operation fails.

### Transaction cost

- Additional coordination and transaction-management overhead.
- More memory and storage pressure from maintaining transaction state.
- Increased contention when many transactions update the same documents.
- Longer transactions can increase resource usage and conflict risk.
- Replica-set transactions require majority acknowledgement for the default transaction write concern.

For simple operations affecting one document, MongoDB's single-document atomicity is generally preferable to a multi-document transaction.

## 5. ACID Properties

| Property | Meaning | Bank Transfer Example |
|---|---|---|
| Atomicity | All operations succeed or fail together | Debit and credit both succeed or both roll back |
| Consistency | Data remains valid | Account balances follow business rules |
| Isolation | Concurrent transactions do not interfere incorrectly | Simultaneous transfers are handled safely |
| Durability | Committed changes persist | Completed transfers remain saved |
