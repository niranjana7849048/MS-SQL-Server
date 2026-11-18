
# Day 6 – Set 1: Retail Sales Reporting
## Expected Results

Database: RetailSalesReporting

### Sample Data Summary

| Table | Number of Records |
|---|---:|
| Customers | 7 |
| Products | 6 |
| Orders | 13 |
| Order_Items | 16 |

---

## SQL Reporting Queries

### Query 1: Top 5 Products by Revenue

**Purpose:** Identify the five products generating the highest total revenue.

**Expected output:**

| Product | Total Revenue |
|---|---:|
| Laptop | 165000 |
| Smartphone | 100000 |
| Office Chair | 24000 |
| Desk | 24000 |
| Headphones | 14000 |

Office Chair and Desk have equal revenue.

### Query 2: Month-wise Sales

**Purpose:** Calculate total sales revenue for each month.

**Expected output:**

| Month | Monthly Revenue |
|---|---:|
| 2026-01 | 150000 |
| 2026-02 | 69500 |
| 2026-03 | 116500 |

### Query 3: Customers with More Than Three Orders

**Purpose:** Find customers who placed more than three orders using GROUP BY and HAVING.

**Expected output:**

| CustomerID | CustomerName | TotalOrders |
|---|---|---:|
| 1 | Arun Kumar | 4 |

### Query 4: Average Basket Value by City

**Purpose:** Calculate the average value of an order for each customer city.

**Expected output:**

| City | Average Basket Value |
|---|---:|
| Chennai | 38583.33 |
| Bangalore | 18000.00 |
| Mumbai | 14000.00 |
| Hyderabad | 4500.00 |

Each order is counted once, regardless of how many products it contains.

### Query 5: Orders Without Payment

**Purpose:** Retrieve orders whose payment status is Pending using LEFT JOIN.

**Expected output:**

| OrderID | CustomerName | PaymentStatus |
|---|---|---|
| 1003 | Arun Kumar | Pending |
| 1007 | Priya Sharma | Pending |
| 1010 | Sneha Raj | Pending |

### Query 6: Customers with No Orders

**Purpose:** Find customers who have not placed any orders using LEFT JOIN and IS NULL.

**Expected output:**

| CustomerID | CustomerName | City |
|---|---|---|
| 7 | Vikram Rao | Mumbai |

### Query 7: Product Category Revenue Share

**Purpose:** Calculate each product category's revenue and percentage contribution to total revenue.

**Expected output:**

| Category | Category Revenue | Revenue Share |
|---|---:|---:|
| Electronics | 265000 | 78.87% |
| Accessories | 23000 | 6.85% |
| Furniture | 48000 | 14.29% |

Percentages may differ slightly due to rounding.

### Query 8: Day with Highest Sales

**Purpose:** Find the date with the highest total sales revenue.

**Expected output:**

| OrderDate | DailyRevenue |
|---|---:|
| 2026-03-12 | 63000 |

---

## SQL Functions Demonstration

Functions used:

| Function | Purpose |
|---|---|
| UPPER() | Converts customer names to uppercase |
| CONCAT() | Combines city name with country |
| DATEDIFF() | Calculates days since an order |
| FORMAT() | Formats dates into a readable format |
| ROUND() | Rounds monetary values to two decimal places |

**Example output format:**

| CustomerName | Location | OrderDate |
|---|---|---|
| ARUN KUMAR | Chennai, India | 05-Jan-2026 |
| PRIYA SHARMA | Bangalore, India | 20-Jan-2026 |

The DaysSinceOrder and OrderAmount columns are calculated dynamically.

---

## NULL Behaviour in SQL Server

### COUNT(*)

Counts every row, including rows containing NULL values.

### COUNT(column)

Counts only non-NULL values in the specified column.

### AVG(column)

Calculates the average using only non-NULL values.

**Example:**

Consider the values:

| Value |
|---:|
| 10 |
| 20 |
| NULL |

Expected results:

| Function | Result |
|---|---:|
| COUNT(*) | 3 |
| COUNT(Value) | 2 |
| AVG(Value) | 15 |

NULL is ignored by COUNT(column) and AVG(column), but COUNT(*) counts the row.

---

## MongoDB Aggregation Pipelines

### Pipeline 1: Month-wise Sales

**Purpose:** Group orders by year and month and calculate monthly revenue.

Expected output:

| Month | Monthly Revenue |
|---|---:|
| January 2026 | 150000 |
| February 2026 | 69500 |
| March 2026 | 116500 |

### Pipeline 2: Top 5 Products

**Purpose:** Calculate product-wise revenue and return the five highest-revenue products.

Expected output:

| Product | Revenue |
|---|---:|
| Laptop | 165000 |
| Smartphone | 100000 |
| Office Chair | 24000 |
| Desk | 24000 |
| Headphones | 14000 |

### Pipeline 3: Average Basket Value by City

**Purpose:** Calculate each order's value and find the average order value by customer city.

Expected output:

| City | Average Basket Value |
|---|---:|
| Chennai | 38583.33 |
| Bangalore | 18000.00 |
| Mumbai | 14000.00 |
| Hyderabad | 4500.00 |

---

## Conclusion

SQL Server reporting uses aggregate functions, GROUP BY, HAVING, joins and built-in functions to generate retail sales reports.

MongoDB aggregation uses $match, $group and $sort, along with $lookup and other stages, to generate equivalent reports from collections.
