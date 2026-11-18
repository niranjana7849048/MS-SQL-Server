# Join and Subquery Explanation – Bank Loan Portfolio

## 1. Equi Join

An equi join combines records from two or more tables using equality between related columns.

**Example:** Display loan details with customer and branch information.

```sql
SELECT
    l.LoanID,
    c.CustomerName,
    b.BranchName,
    l.LoanType,
    l.PrincipalAmount
FROM Loans l
INNER JOIN Customers c
    ON l.CustomerID = c.CustomerID
INNER JOIN Branches b
    ON l.BranchID = b.BranchID;
```

**Explanation:** The `CustomerID` and `BranchID` columns connect loans with their respective customers and branches.

## 2. Self Join and Related Customer Relationships

A self join connects a table to itself. In this assignment, the `Customers` table is used to identify customers who act as guarantors and borrowers.

**Example:** Find guarantors who also have their own loans.

```sql
SELECT DISTINCT
    c.CustomerID,
    c.CustomerName
FROM LoanGuarantors g
INNER JOIN Customers c
    ON g.GuarantorCustomerID = c.CustomerID
WHERE EXISTS (
    SELECT 1
    FROM Loans l
    WHERE l.CustomerID = c.CustomerID
);
```

**Explanation:** The query identifies guarantors who also appear as borrowers in the `Loans` table. This is a related-entity comparison rather than a literal self join; the actual self-referential relationship is between two roles played by the same customer entity.

## 3. LEFT JOIN

A left join returns every record from the left table and matching records from the right table. Unmatched right-side columns contain NULL.

**Example:** Find branches without loans.

```sql
SELECT
    b.BranchID,
    b.BranchName
FROM Branches b
LEFT JOIN Loans l
    ON b.BranchID = l.BranchID
WHERE l.LoanID IS NULL;
```

**Explanation:** All branches are considered. Branches without matching loans are returned.

## 4. Subquery Using IN

The `IN` operator checks whether a value exists in a list returned by a subquery.

**Example:** Find customers who have taken a Home Loan.

```sql
SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Loans
    WHERE LoanType = 'Home Loan'
);
```

**Explanation:** The inner query retrieves customer IDs with Home Loans. The outer query returns their names.

## 5. Subquery Using EXISTS

The `EXISTS` operator checks whether a subquery returns at least one row.

**Example:** Find customers who have at least one loan.

```sql
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Loans l
    WHERE l.CustomerID = c.CustomerID
);
```

**Explanation:** A customer is returned if at least one matching loan exists.

## 6. Subquery Using NOT EXISTS

`NOT EXISTS` checks whether a subquery returns no matching rows.

**Example:** Find loans without a repayment in the last 60 days.

```sql
SELECT
    l.LoanID,
    l.LoanType
FROM Loans l
WHERE NOT EXISTS (
    SELECT 1
    FROM Repayments r
    WHERE r.LoanID = l.LoanID
      AND r.PaymentStatus = 'Paid'
      AND r.RepaymentDate >= DATEADD(
          DAY, -60, CAST('2026-11-18' AS DATE)
      )
      AND r.RepaymentDate <= CAST('2026-11-18' AS DATE)
);
```

**Explanation:** The query returns loans for which no qualifying recent repayment record exists.

## 7. Correlated Subquery

A correlated subquery uses a value from the outer query. It is evaluated in relation to each outer row.

**Example:** Find loans whose principal amount is greater than the average loan amount of their branch.

```sql
SELECT
    l.LoanID,
    l.BranchID,
    l.PrincipalAmount
FROM Loans l
WHERE l.PrincipalAmount > (
    SELECT AVG(l2.PrincipalAmount)
    FROM Loans l2
    WHERE l2.BranchID = l.BranchID
);
```

**Explanation:** The inner query calculates the average principal amount for the branch associated with the current loan.

## 8. Nested Subquery

A nested subquery contains another query inside it.

**Example:** Find branches whose highest loan amount is above the average of all branch maximum loan amounts.

```sql
SELECT
    b.BranchID,
    b.BranchName,
    MAX(l.PrincipalAmount) AS HighestLoan
FROM Branches b
INNER JOIN Loans l
    ON b.BranchID = l.BranchID
GROUP BY
    b.BranchID,
    b.BranchName
HAVING MAX(l.PrincipalAmount) > (
    SELECT AVG(BranchMaximum)
    FROM (
        SELECT MAX(PrincipalAmount) AS BranchMaximum
        FROM Loans
        GROUP BY BranchID
    ) AS BranchMaxima
);
```

**Explanation:** The inner query calculates the maximum loan amount for each branch. The outer subquery calculates the average of those maximum values.

## 9. MongoDB $lookup

MongoDB uses `$lookup` to combine related documents from different collections.

**Example:** Retrieve loans with customer details.

```javascript
db.loans.aggregate([
    {
        $lookup: {
            from: "customers",
            localField: "customerId",
            foreignField: "customerId",
            as: "customerDetails"
        }
    }
]);
```

**Explanation:**
- `from`: Collection to join.
- `localField`: Matching field in the current collection.
- `foreignField`: Matching field in the other collection.
- `as`: Name of the resulting array field.

## 10. MongoDB $lookup with Pipeline

A pipeline inside `$lookup` allows filtering and processing joined documents.

**Example:** Retrieve recent repayments for each loan.

```javascript
db.loans.aggregate([
    {
        $lookup: {
            from: "repayments",
            let: {
                currentLoanId: "$loanId"
            },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                {
                                    $eq: [
                                        "$loanId",
                                        "$$currentLoanId"
                                    ]
                                },
                                {
                                    $eq: [
                                        "$paymentStatus",
                                        "Paid"
                                    ]
                                }
                            ]
                        }
                    }
                }
            ],
            as: "paidRepayments"
        }
    }
]);
```

**Explanation:** The `let` variable passes the current loan ID into the lookup pipeline. `$expr` allows comparison with that variable.

## 11. SQL Joins vs MongoDB $lookup

| Feature | SQL | MongoDB |
|---|---|---|
| Data storage | Tables | Collections |
| Equi join | INNER JOIN | $lookup with matching fields |
| Left outer join | LEFT JOIN | $lookup |
| Self join | Join table with itself | $lookup on the same collection |
| Filtering joined records | WHERE | $match |
| Grouping | GROUP BY | $group |
| Sorting | ORDER BY | $sort |

## 12. Conclusion

This assignment demonstrates how SQL joins and subqueries can be used to analyse bank loan data.

It also demonstrates how MongoDB's `$lookup` stage combines related documents across collections.

These techniques help banks analyse loan exposure, customer relationships, branch performance, guarantor information, and repayment activity.