
# Why MongoDB is Suitable for Bank Activity Logs

MongoDB is suitable for storing customer activity logs because:

1. **Flexible schema:** Different events such as login, logout, balance checks and fund transfers can contain different details.
2. **High write volume:** Activity logs are frequently generated and MongoDB handles document insertions efficiently.
3. **Capped collection:** A capped collection maintains a fixed storage limit and automatically removes older records when the limit is reached.
4. **Easy querying:** MongoDB supports filtering, sorting and limiting records. For example, the last five login events of a customer can be retrieved using `find()`, `sort()` and `limit()`.

## Why not SQL Server?

SQL Server is better suited for structured banking data such as customers, accounts, branches and balances because it provides relational constraints and transaction support.

MongoDB is used for activity logs because they are semi-structured and may have different event details.

## Conclusion

SQL Server is used for core banking records, while MongoDB is used for customer activity logs. This approach uses each database according to its strengths.
