# Join and Subquery Explanation – Logistics Shipment Analysis

## 1. Equi Join

An equi join combines rows from two tables using an equality condition between related columns.

**Example:** Display shipment details with customer names.

```sql
SELECT
    s.ShipmentID,
    s.TrackingNumber,
    c.CustomerName,
    s.ShippingCost
FROM Shipments s
INNER JOIN Customers c
    ON s.CustomerID = c.CustomerID;
```

**Explanation:** The `CustomerID` column connects the `Shipments` and `Customers` tables. Only matching records are returned.

## 2. Self Join

A self join joins a table with itself. It is useful for representing hierarchical relationships.

**Example:** Display employees and their supervisors.

```sql
SELECT
    e.EmployeeName AS Employee,
    m.EmployeeName AS Supervisor
FROM Employees e
LEFT JOIN Employees m
    ON e.SupervisorID = m.EmployeeID;
```

**Explanation:** The same `Employees` table is referenced twice using different aliases. The first alias represents the employee, and the second represents the supervisor.

## 3. LEFT JOIN

A left join returns all rows from the left table and matching rows from the right table. If there is no match, the right-side columns contain NULL.

**Example:** Find hubs without outbound shipments.

```sql
SELECT
    h.HubID,
    h.HubName
FROM Hubs h
LEFT JOIN Shipments s
    ON h.HubID = s.OriginHubID
WHERE s.ShipmentID IS NULL;
```

**Explanation:** This identifies hubs that do not appear as the origin of any shipment.

## 4. FULL OUTER JOIN

A full outer join returns matching and non-matching records from both tables.

**Example:** Display all shipments and delivery events.

```sql
SELECT
    s.ShipmentID,
    s.TrackingNumber,
    d.EventID,
    d.EventType
FROM Shipments s
FULL OUTER JOIN DeliveryEvents d
    ON s.ShipmentID = d.ShipmentID;
```

**Explanation:** All shipments and all delivery events are included. Unmatched records from either side contain NULL values for the other table's columns.

## 5. Subquery Using IN

The `IN` operator checks whether a value matches any value returned by a subquery.

**Example:** Find customers who shipped to Mumbai Hub.

```sql
SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Shipments
    WHERE DestinationHubID = 4
);
```

**Explanation:** The inner query retrieves customers who have shipments destined for Hub 4. The outer query displays their details.

## 6. Subquery Using EXISTS

The `EXISTS` operator checks whether a subquery returns at least one row.

**Example:** Find customers who have delayed shipments.

```sql
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Shipments s
    WHERE s.CustomerID = c.CustomerID
      AND s.ShipmentStatus = 'Delayed'
);
```

**Explanation:** The outer query checks each customer. If at least one delayed shipment exists for that customer, the customer is included.

## 7. Subquery Using ANY

`ANY` compares a value with at least one value returned by a subquery.

**Example:** Find shipments whose shipping cost is greater than at least one shipment cost handled by Carrier 1.

```sql
SELECT
    ShipmentID,
    ShippingCost
FROM Shipments
WHERE ShippingCost > ANY (
    SELECT ShippingCost
    FROM Shipments
    WHERE CarrierID = 1
);
```

**Explanation:** A shipment is returned if its cost is greater than at least one cost in the subquery result.

## 8. Subquery Using ALL

`ALL` compares a value with every value returned by a subquery.

**Example:** Find shipments whose shipping cost is greater than every shipment cost handled by Carrier 1.

```sql
SELECT
    ShipmentID,
    ShippingCost
FROM Shipments
WHERE ShippingCost > ALL (
    SELECT ShippingCost
    FROM Shipments
    WHERE CarrierID = 1
);
```

**Explanation:** A shipment is returned only if its cost is greater than all costs returned by the inner query.

## 9. Correlated Subquery

A correlated subquery depends on values from the outer query and is evaluated in relation to each outer row.

**Example:** Find shipments whose shipping cost is above their carrier's average shipping cost.

```sql
SELECT
    s.ShipmentID,
    s.CarrierID,
    s.ShippingCost
FROM Shipments s
WHERE s.ShippingCost > (
    SELECT AVG(s2.ShippingCost)
    FROM Shipments s2
    WHERE s2.CarrierID = s.CarrierID
);
```

**Explanation:** The inner query calculates the average shipping cost for the carrier associated with the current outer shipment.

## 10. Nested Subquery

A nested subquery contains another query inside it.

**Example:** Find the second-highest distinct shipping cost for each origin hub.

```sql
SELECT
    h.HubID,
    h.HubName,
    (
        SELECT MAX(s1.ShippingCost)
        FROM Shipments s1
        WHERE s1.OriginHubID = h.HubID
          AND s1.ShippingCost < (
              SELECT MAX(s2.ShippingCost)
              FROM Shipments s2
              WHERE s2.OriginHubID = h.HubID
          )
    ) AS SecondHighestShippingCost
FROM Hubs h;
```

**Explanation:** The innermost query finds the highest cost for a hub. The next query finds the maximum cost below that value.

## 11. MongoDB $lookup

MongoDB's `$lookup` stage performs a left outer join between collections.

**Example:** Retrieve shipments along with their customer information.

```javascript
db.shipments.aggregate([
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
- `localField`: Field in the current collection.
- `foreignField`: Matching field in the other collection.
- `as`: Name of the resulting array field.

## 12. SQL Joins vs MongoDB $lookup

| Feature | SQL Joins | MongoDB $lookup |
|---|---|---|
| Data storage | Tables | Collections |
| Relationship | Primary and foreign keys | Matching document fields |
| Inner join | INNER JOIN | $lookup followed by filtering |
| Left outer join | LEFT JOIN | $lookup |
| Self join | Join table with itself | $lookup on the same collection |
| Multiple relationships | Multiple JOIN clauses | Multiple $lookup stages |

## 13. Conclusion

This assignment demonstrates relational data analysis using SQL joins and subqueries, along with MongoDB aggregation and `$lookup`.

These techniques help combine related information, identify missing relationships, calculate shipment statistics, and retrieve meaningful business reports.