
# Day 6 – Set 2: Insurance Policy Reporting

Database: InsuranceReporting

## 1. Sample Data Summary

| Table | Records |
|---|---:|
| Customers | 8 |
| Agents | 5 |
| Products | 4 |
| Policies | 10 |
| Premiums | 11 |
| Claims | 8 |

---

## 2. SQL Reporting Queries

### Query 1: Policies Expiring in the Next 30 Days

**Purpose:** Identify active policies approaching their expiry date.

**Expected output when executed on 18 November 2026:**

| PolicyID | PolicyNumber | ExpiryDate |
|---|---|---|
| 1004 | POL100004 | 2026-11-25 |
| 1002 | POL100002 | 2026-12-05 |
| 1001 | POL100001 | 2026-12-10 |

The result changes depending on the execution date.

### Query 2: Premium Collected per Product

**Purpose:** Calculate the total successfully collected premium for each insurance product.

**Expected output:**

| Product | Premium Collected |
|---|---:|
| Life Insurance | 67000 |
| Health Insurance | 64000 |
| Motor Insurance | 22000 |
| Travel Insurance | 8000 |

Only payments with status Paid are included.

### Query 3: Customers with More Than One Active Policy

**Purpose:** Find customers holding multiple active insurance policies.

**Expected output:**

| CustomerID | CustomerName | ActivePolicyCount |
|---|---|---:|
| 1 | Arun Kumar | 2 |
| 2 | Priya Sharma | 2 |

### Query 4: Claim Ratio per Product

**Purpose:** Compare claim amounts with premium amounts for products having claims.

**Expected output from the supplied query:**

| Product | Total Claim Amount | Joined Premium Amount | Claim Ratio |
|---|---:|---:|---:|
| Health Insurance | 11000 | 46000 | 23.91% |
| Life Insurance | 18000 | 45000 | 40.00% |
| Motor Insurance | 9000 | 22000 | 40.91% |

Note: This query joins claims and policies directly. If a policy has multiple claims, its premium is counted more than once. The denominator is therefore a joined premium total, not a unique-policy premium total.

### Query 5: Policies Without Claims

**Purpose:** Identify policies that have no associated claim records.

**Expected output:**

| PolicyID | PolicyNumber |
|---|---|
| 1005 | POL100005 |
| 1009 | POL100009 |
| 1010 | POL100010 |

### Query 6: Average Premium by Age Band

**Purpose:** Group customers by age band and calculate their average policy premium.

**Expected output using the supplied sample data and execution date 18 November 2026:**

| Age Band | Average Premium |
|---|---:|
| Below 30 | 11000.00 |
| 30-44 | 19000.00 |
| 45-59 | 13000.00 |

The age calculation uses DATEDIFF(YEAR), which counts calendar-year boundaries rather than checking whether the birthday has occurred.

### Query 7: Monthly New Policies

**Purpose:** Count newly started policies month by month.

**Expected output:**

| Policy Month | New Policies |
|---|---:|
| 2024-01 | 1 |
| 2025-01 | 1 |
| 2025-05 | 1 |
| 2025-06 | 1 |
| 2026-01 | 2 |
| 2026-02 | 1 |
| 2026-03 | 1 |
| 2026-04 | 1 |
| 2026-05 | 1 |

### Query 8: Top 5 Agents by Premium

**Purpose:** Rank agents according to successfully collected premiums.

**Expected output:**

| Agent | Total Premium |
|---|---:|
| Ramesh Kumar | 42000 |
| Suresh Raj | 41000 |
| Anita Sharma | 38000 |
| Kavitha Nair | 32000 |
| Vijay Rao | 8000 |

---

## 3. SQL Functions Demonstration

| Function | Purpose |
|---|---|
| DATEADD() | Calculates a date 30 days ahead |
| DATEDIFF() | Calculates remaining days and policy age |
| CASE | Categorizes customers into age bands |
| LEFT() | Extracts the beginning of a policy number |
| RIGHT() | Extracts the ending of a policy number |
| CONCAT() | Combines strings |
| FORMAT() | Formats dates into year-month output |

**Example masked policy number:**

| Original | Masked |
|---|---|
| POL100001 | POL****001 |
| POL100002 | POL****002 |
| POL100003 | POL****003 |

---

## 4. WHERE vs HAVING

### WHERE

- Filters individual rows before grouping.
- Used to select only Active policies.

### HAVING

- Filters groups after GROUP BY.
- Used to select customers with more than one policy.

Example:

WHERE PolicyStatus = 'Active'

HAVING COUNT(*) > 1

---

## 5. MongoDB Aggregation Pipelines

### Pipeline 1: Claims per Status

**Purpose:** Count claims and calculate claim amounts by status.

**Expected output:**

| Status | Total Claims | Claim Amount |
|---|---:|---:|
| Settled | 5 | 29000 |
| Pending | 2 | 8500 |
| Under Review | 1 | 3000 |

### Pipeline 2: Average Settlement Time

**Purpose:** Calculate the average number of days taken to settle completed claims.

**Expected output:**

| Settled Claims | Average Settlement Days |
|---:|---:|
| 5 | 10.60 |

Unsettled claims are excluded.

### Pipeline 3: Top 3 Damage Categories

**Purpose:** Identify the three most frequently reported damage categories.

**Expected output:**

| Damage Category | Total Claims | Claim Amount |
|---|---:|---:|
| Medical | 3 | 11000 |
| Life | 2 | 18000 |
| Accident | 1 | 6000 |

---

## 6. Conclusion

SQL Server aggregate functions, GROUP BY, HAVING, joins and date/string functions help generate insurance management reports.

MongoDB aggregation pipelines use $match, $group and $sort to summarize claim records, settlement durations and damage categories.
