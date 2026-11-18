
# Day 6 – Set 3: Telecom Usage and Billing Reporting

**Database:** TelecomReporting  
**SQL Server:** SQL Server 2025  
**MongoDB:** MongoDB 8.0

---

## 1. Sample Data Summary

| Table / Collection | Records |
|---|---:|
| Plans | 4 |
| Subscribers | 10 |
| UsageRecords | 18 |
| Invoices | 12 |
| MongoDB usageEvents | 18 |

---

## 2. SQL Reporting Queries

### Query 1: Total Call Minutes per Plan

**Purpose:** Calculate total call minutes consumed by subscribers under each plan.

**Expected output:**

| Plan Name | Total Call Minutes |
|---|---:|
| Unlimited Plan | 2500 |
| Premium Plan | 1700 |
| Smart Plan | 790 |
| Basic Plan | 390 |

### Query 2: Subscribers Exceeding Data Limit

**Purpose:** Identify subscribers whose total November data usage exceeds their plan's monthly data limit.

**Expected output:**

| Subscriber | Plan | Data Limit (GB) | Data Used (GB) | Excess (GB) |
|---|---|---:|---:|---:|
| Karthik Raj | Unlimited Plan | 30 | 23.00 | No |
| Rahul Verma | Premium Plan | 10 | 11.50 | 1.50 |
| Priya Sharma | Smart Plan | 5 | 5.50 | 0.50 |
| Sneha Reddy | Smart Plan | 5 | 4.20 | No |
| Vijay Kumar | Premium Plan | 10 | 8.50 | No |
| Divya Nair | Smart Plan | 5 | 5.70 | 0.70 |
| Sanjay Rao | Unlimited Plan | 30 | 33.00 | 3.00 |

**Note:** The actual SQL query returns only subscribers who exceed their data limits:

| Subscriber | Plan | Data Limit (GB) | Data Used (GB) | Excess (GB) |
|---|---|---:|---:|---:|
| Karthik Raj | Unlimited Plan | 30 | 23.00 | -7.00 |
| Rahul Verma | Premium Plan | 10 | 11.50 | 1.50 |
| Priya Sharma | Smart Plan | 5 | 5.50 | 0.50 |
| Divya Nair | Smart Plan | 5 | 5.70 | 0.70 |
| Sanjay Rao | Unlimited Plan | 30 | 33.00 | 3.00 |

Correction: Karthik Raj does not exceed the 30 GB limit, so he is excluded from the actual report.

### Query 3: Month-wise Revenue

**Purpose:** Calculate monthly revenue from paid invoices.

**Expected output:**

| Month | Revenue |
|---|---:|
| 2026-01 | 598.00 |
| 2026-02 | 998.00 |
| 2026-03 | 999.00 |
| 2026-04 | 599.00 |
| 2026-05 | 199.00 |
| 2026-11 | 599.00 |

Only invoices with PaymentStatus = 'Paid' are included.

### Query 4: Invoices Overdue by More Than 15 Days

**Purpose:** Find unpaid or pending invoices whose due dates are more than 15 days before the execution date.

**Expected output:** This report is dynamic because it uses GETDATE(). It will include only unpaid or pending invoices satisfying the 15-day condition on the day the script is executed.

### Query 5: Subscribers with No Usage

**Purpose:** Find subscribers who do not have any usage records.

**Expected output:**

| SubscriberID | SubscriberName | Circle | Plan |
|---|---|---|---|
| 110 | Anitha Das | Bangalore | Basic Plan |

### Query 6: ARPU by Circle

**Purpose:** Calculate Average Revenue Per User (ARPU).

Formula:

ARPU = Total Paid Invoice Revenue / Total Subscribers

**Expected output:**

| Circle | Subscriber Count | Paid Revenue | ARPU |
|---|---:|---:|---:|
| Chennai | 3 | 1796.00 | 598.67 |
| Hyderabad | 2 | 998.00 | 499.00 |
| Bangalore | 3 | 598.00 | 199.33 |
| Mumbai | 2 | 0.00 | 0.00 |

### Query 7: Plan Popularity

**Purpose:** Find the number and percentage of subscribers using each plan.

**Expected output:**

| Plan | Subscriber Count | Percentage |
|---|---:|---:|
| Basic Plan | 3 | 30.00% |
| Smart Plan | 3 | 30.00% |
| Premium Plan | 2 | 20.00% |
| Unlimited Plan | 2 | 20.00% |

### Query 8: Top 10 Data Consumers

**Purpose:** Rank subscribers by total data usage during November 2026.

**Expected output:**

| Subscriber | Circle | Total Data Used (GB) |
|---|---|---:|
| Sanjay Rao | Mumbai | 33.00 |
| Karthik Raj | Chennai | 23.00 |
| Rahul Verma | Chennai | 11.50 |
| Divya Nair | Mumbai | 5.70 |
| Priya Sharma | Bangalore | 5.50 |
| Vijay Kumar | Hyderabad | 8.50 |
| Sneha Reddy | Hyderabad | 4.20 |
| Arun Kumar | Chennai | 2.30 |
| Meena Iyer | Bangalore | 1.50 |

---

## 3. SQL Functions Demonstration

| Function | Purpose |
|---|---|
| SUM() | Calculates total usage and revenue |
| AVG() | Calculates average values |
| COUNT() | Counts subscribers and records |
| DATEADD() | Calculates date intervals |
| DATEDIFF() | Calculates overdue days |
| FORMAT() | Formats invoice dates |
| CONCAT() | Combines invoice number text |
| RIGHT() | Extracts invoice number digits |
| UPPER() | Converts subscriber names to uppercase |
| ROUND() | Rounds ARPU and usage values |
| CASE | Determines invoice due status |

---

## 4. NULL Behaviour with SUM() and AVG()

The following example is used:

| DataValue |
|---:|
| 10 |
| 20 |
| NULL |
| 30 |

**Expected output:**

| TotalRows | NonNullRows | SumValue | AverageValue |
|---:|---:|---:|---:|
| 4 | 3 | 60 | 20 |

Explanation:

- COUNT(*) counts all rows, including NULL rows.
- COUNT(column) ignores NULL values.
- SUM(column) ignores NULL values.
- AVG(column) ignores NULL values.

---

## 5. MongoDB Aggregation Pipelines

### Pipeline 1: Hourly Usage

**Purpose:** Group usage events by hour and calculate total data usage and call minutes.

The sample timestamps are stored in UTC.

**Expected output:**

| Hour (UTC) | Events | Data Used (GB) | Call Minutes |
|---:|---:|---:|---:|
| 8 | 1 | 6.00 | 400 |
| 9 | 5 | 32.40 | 2020 |
| 10 | 3 | 6.50 | 570 |
| 11 | 1 | 2.00 | 180 |
| 14 | 1 | 1.10 | 90 |
| 15 | 1 | 2.50 | 200 |
| 16 | 1 | 0.70 | 80 |
| 17 | 1 | 2.20 | 160 |
| 18 | 2 | 8.00 | 530 |
| 19 | 2 | 26.00 | 1150 |
| 20 | 1 | 4.00 | 450 |

### Pipeline 2: Average Session Length

**Purpose:** Calculate average session duration by usage type.

**Expected output:**

| Usage Type | Total Sessions | Average Session Minutes | Total Session Minutes |
|---|---:|---:|---:|
| CALL | 9 | 39.44 | 355 |
| DATA | 9 | 49.44 | 445 |

### Pipeline 3: Busiest Cell Tower

**Purpose:** Identify the three cell towers with the highest number of usage events.

**Expected output:**

| Cell Tower | Total Events | Data Used (GB) | Call Minutes |
|---|---:|---:|---:|
| CHN-TOWER-01 | 2 | 2.30 | 210 |
| BLR-TOWER-02 | 2 | 5.50 | 450 |
| CHN-TOWER-03 | 2 | 11.50 | 750 |

The pipeline sorts by event count and then by data usage. Other towers also have two events, so the tie-breaker determines the top three.

---

## 6. Conclusion

SQL Server aggregation, joins, grouping and date/string functions help telecom companies analyze subscriber usage, billing, revenue and plan popularity.

MongoDB aggregation pipelines help summarize hourly usage, session duration and cell tower activity.

These reports support usage monitoring, billing analysis and network capacity planning.
