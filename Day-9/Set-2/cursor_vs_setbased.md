# Cursor vs Set-Based Processing – Insurance Premium Processing

## 1. Cursor Approach

The cursor processes policies individually.

In this assignment:
- Identifies policies whose renewal dates have passed.
- Fetches each eligible policy one at a time.
- Updates its status to `Lapsed`.
- Inserts an audit entry for each updated policy.

## 2. Set-Based Approach

The set-based approach processes multiple policies through SQL statements.

In this assignment:
- Uses `INSERT INTO ... SELECT` to log eligible policies.
- Uses a single `UPDATE` statement to change their statuses.
- Processes all eligible policies together.

## 3. Comparison

| Feature | Cursor | Set-Based |
|---|---|---|
| Processing | Row by row | Multiple rows together |
| Performance | Usually slower | Usually faster |
| Code complexity | More complex | Simpler |
| Resource usage | Higher overhead | Generally lower overhead |
| Best suited for | Individual record operations | Bulk updates |

## 4. Conclusion

The set-based approach is generally more efficient for bulk policy updates. Cursors are useful when individual processing or complex row-specific operations are required.