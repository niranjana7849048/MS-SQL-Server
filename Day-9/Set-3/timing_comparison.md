# Cursor vs Set-Based Execution – Telecom Low-Balance Follow-up

## 1. Cursor Approach

The cursor processes each prepaid subscriber individually.

- Finds subscribers whose balance is below 50.
- Fetches each subscriber one at a time.
- Inserts a notification for each eligible subscriber.

## 2. Set-Based Approach

The set-based approach uses a single `INSERT INTO ... SELECT` statement.

- Identifies all prepaid subscribers with balances below 50.
- Inserts notifications for all qualifying subscribers together.
- Avoids row-by-row processing.

## 3. Execution Time Comparison

| Metric | Cursor | Set-Based |
|---|---|---|
| Processing | Row by row | Bulk processing |
| Execution time | To be measured | To be measured |
| Performance | Usually slower for large datasets | Usually faster |
| Resource usage | Higher overhead | Generally lower overhead |

## 4. Conclusion

The set-based approach is generally more efficient for bulk notification insertion. The actual execution times should be measured using SQL Server execution statistics with the same test data and database conditions.