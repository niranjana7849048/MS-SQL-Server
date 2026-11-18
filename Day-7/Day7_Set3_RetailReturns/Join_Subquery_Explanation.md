
# Day 7 – Set 3: Retail Returns and Refunds

## 1. Business Scenario

A retail company manages customers, employees, products, orders, returned products, and refunds.

The reporting team needs to analyze:
- Customer return activity.
- Products that are frequently returned.
- Products that have never been returned.
- Refund amounts and refund statuses.
- Employees handling product returns.
- Employee-manager relationships.

SQL Server uses joins and subqueries to retrieve related records. MongoDB uses the `$lookup` aggregation stage to combine documents from different collections.

---

## 2. Equi Join

An equi join combines records from two or more tables using equality between related columns.

Example:

```sql
SELECT
    r.ReturnID,
    p.ProductName,
    r.ReturnReason
FROM Returns r
INNER JOIN OrderItems oi
    ON r.OrderItemID = oi.OrderItemID
INNER JOIN Products p
    ON oi.ProductID = p.ProductID;
```

Explanation:

- `Returns` stores return information.
- `OrderItems` connects returned items to products.
- `Products` provides product details.
- Equality conditions connect the tables.

Use case: Display product names and reasons for product returns.

---

## 3. Self Join

A self join joins a table with itself.

Example:

```sql
SELECT
    e.EmployeeName AS Employee,
    m.EmployeeName AS Manager
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID;
```

Explanation:

- Both aliases refer to the `Employees` table.
- `e` represents the employee.
- `m` represents the manager.
- `ManagerID` refers to another employee's `EmployeeID`.
- `LEFT JOIN` includes employees who do not have a manager.

Use case: Display the employee-manager hierarchy.

---

## 4. IN Subquery

The `IN` operator checks whether a value matches any value returned by a subquery.

Example:

```sql
SELECT
    ProductID,
    ProductName
FROM Products
WHERE ProductID IN (
    SELECT oi.ProductID
    FROM OrderItems oi
    INNER JOIN Returns r
        ON oi.OrderItemID = r.OrderItemID
);
```

Explanation:

The inner query retrieves product IDs associated with returns.

The outer query displays matching product details.

Use case: Find products that have been returned.

---

## 5. NOT IN Subquery

`NOT IN` selects records whose values do not appear in the subquery result.

Example:

```sql
SELECT
    ProductID,
    ProductName
FROM Products
WHERE ProductID NOT IN (
    SELECT oi.ProductID
    FROM OrderItems oi
    INNER JOIN Returns r
        ON oi.OrderItemID = r.OrderItemID
);
```

Explanation:

This query finds products that have never been returned.

Note: `NOT IN` can behave unexpectedly if the subquery returns NULL. `NOT EXISTS` is often safer when NULL values are possible.

---

## 6. EXISTS Subquery

`EXISTS` checks whether a subquery returns at least one row.

Example:

```sql
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    INNER JOIN OrderItems oi
        ON o.OrderID = oi.OrderID
    INNER JOIN Returns r
        ON oi.OrderItemID = r.OrderItemID
    WHERE o.CustomerID = c.CustomerID
);
```

Explanation:

- The subquery checks whether the customer has any returned order item.
- If at least one matching record exists, the customer is selected.
- `SELECT 1` is commonly used because only row existence matters.

Use case: Find customers who have made returns.

---

## 7. NOT EXISTS Subquery

`NOT EXISTS` selects records for which the subquery returns no rows.

Example:

```sql
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    INNER JOIN OrderItems oi
        ON o.OrderID = oi.OrderID
    INNER JOIN Returns r
        ON oi.OrderItemID = r.OrderItemID
    WHERE o.CustomerID = c.CustomerID
);
```

Explanation:

This query identifies customers who have never returned a product.

---

## 8. ANY Operator

`ANY` compares a value with at least one value returned by a subquery.

Example:

```sql
SELECT
    ProductName,
    Price
FROM Products
WHERE Price > ANY (
    SELECT p.Price
    FROM Products p
    INNER JOIN OrderItems oi
        ON p.ProductID = oi.ProductID
    INNER JOIN Returns r
        ON oi.OrderItemID = r.OrderItemID
);
```

Explanation:

A product is selected if its price is greater than at least one returned product's price.

Equivalent idea:

```sql
Price > ANY (subquery)
```

means the price is greater than the minimum value returned by the subquery, provided the subquery is nonempty and has no NULL complications.

---

## 9. ALL Operator

`ALL` compares a value with every value returned by a subquery.

Example:

```sql
SELECT
    ProductName,
    Price
FROM Products
WHERE Price > ALL (
    SELECT p.Price
    FROM Products p
    INNER JOIN OrderItems oi
        ON p.ProductID = oi.ProductID
    INNER JOIN Returns r
        ON oi.OrderItemID = r.OrderItemID
);
```

Explanation:

A product is selected only if its price is greater than every returned product's price.

Equivalent idea:

```sql
Price > ALL (subquery)
```

means the price is greater than the maximum value returned by a nonempty subquery, provided there are no NULL complications.

---

## 10. Nested Subquery

A nested subquery is a query placed inside another query.

Example:

```sql
SELECT
    RefundID,
    RefundAmount,
    RefundStatus
FROM Refunds
WHERE RefundAmount > (
    SELECT AVG(RefundAmount)
    FROM Refunds
);
```

Explanation:

- The inner query calculates the average refund amount.
- The outer query selects refunds greater than that average.

Use case: Identify unusually high refunds.

---

## 11. Correlated Subquery

A correlated subquery refers to a column from the outer query.

Example:

```sql
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);
```

Explanation:

- The inner query refers to `c.CustomerID`.
- It is evaluated in relation to each outer customer.
- Customers with at least one order are returned.

---

## 12. MongoDB $lookup

`$lookup` is an aggregation stage used to combine documents from another collection.

Example:

```javascript
db.returns.aggregate([
    {
        $lookup: {
            from: "orderItems",
            localField: "orderItemId",
            foreignField: "orderItemId",
            as: "item"
        }
    }
]);
```

Explanation:

- `from`: Collection to join.
- `localField`: Field in the current collection.
- `foreignField`: Matching field in the other collection.
- `as`: Name of the resulting array field.

Use case: Connect return records with their corresponding order items.

---

## 13. MongoDB Self-Reference Using $lookup

MongoDB can join a collection with itself.

Example:

```javascript
db.employees.aggregate([
    {
        $lookup: {
            from: "employees",
            localField: "managerId",
            foreignField: "employeeId",
            as: "manager"
        }
    }
]);
```

Explanation:

The employee's `managerId` matches the manager's `employeeId` in the same collection.

Use case: Retrieve employee-manager relationships.

---

## 14. SQL Joins vs MongoDB $lookup

| Feature | SQL Server | MongoDB |
|---|---|---|
| Equi Join | INNER JOIN | $lookup |
| Left Join | LEFT JOIN | $lookup with empty-array handling |
| Self Join | Join table with itself | $lookup on same collection |
| Multiple table join | Multiple JOIN clauses | Multiple $lookup stages |
| Filtering related records | WHERE / EXISTS | $match after $lookup |
| Grouping | GROUP BY | $group |
| Selecting fields | SELECT | $project |

---

## 15. Reports Implemented

### SQL Server

1. Return details using equi joins.
2. Employee-manager relationships using self join.
3. Products never returned using NOT IN.
4. Customers with returns using EXISTS.
5. Customers without returns using NOT EXISTS.
6. Products priced above ANY returned product price.
7. Products priced above ALL returned product prices.
8. Refunds above average using a nested subquery.
9. Total refund amount by customer.
10. Products returned more than the average return count.
11. Refund status summary.
12. Returns handled by employees.

### MongoDB

1. Return details using multiple `$lookup` stages.
2. Employee-manager relationships using self-reference `$lookup`.
3. Products never returned.
4. Customers with returns.
5. Customers without returns.
6. Total refund amount by customer.
7. Refund status summary.
8. Return count by product.
9. Refunds above average.
10. Returns handled by employees.

---

## 16. Conclusion

This assignment demonstrates how SQL Server joins and subqueries and MongoDB aggregation lookups can retrieve and analyze related retail data.

The reports help the retail company monitor returns, understand refund activity, identify frequently returned products, and track employee performance.
