
-- =========================================
-- DAY 6 - SET 2: INSURANCE POLICY REPORTING
-- =========================================

CREATE DATABASE InsuranceReporting;
GO

USE InsuranceReporting;
GO

-- =========================================
-- 1. CREATE TABLES
-- =========================================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Agents (
    AgentID INT PRIMARY KEY,
    AgentName VARCHAR(100) NOT NULL,
    City VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50)
);

CREATE TABLE Policies (
    PolicyID INT PRIMARY KEY,
    PolicyNumber VARCHAR(30) UNIQUE NOT NULL,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    AgentID INT NOT NULL,
    StartDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    PremiumAmount DECIMAL(12,2) NOT NULL CHECK (PremiumAmount >= 0),
    PolicyStatus VARCHAR(20) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
    CHECK (ExpiryDate > StartDate),
    CHECK (PolicyStatus IN ('Active', 'Expired', 'Cancelled'))
);

CREATE TABLE Premiums (
    PremiumID INT PRIMARY KEY,
    PolicyID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(12,2) NOT NULL CHECK (Amount >= 0),
    PaymentStatus VARCHAR(20) NOT NULL,
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY,
    PolicyID INT NOT NULL,
    ClaimDate DATE NOT NULL,
    SettlementDate DATE NULL,
    ClaimAmount DECIMAL(12,2) NOT NULL CHECK (ClaimAmount >= 0),
    SettlementAmount DECIMAL(12,2) NULL,
    ClaimStatus VARCHAR(20) NOT NULL,
    DamageCategory VARCHAR(50),
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);
GO

-- =========================================
-- 2. INSERT SAMPLE DATA
-- =========================================

INSERT INTO Customers VALUES
(1, 'Arun Kumar', '1990-05-12', 'arun@gmail.com'),
(2, 'Priya Sharma', '1985-08-20', 'priya@gmail.com'),
(3, 'Rahul Verma', '1998-02-15', 'rahul@gmail.com'),
(4, 'Sneha Raj', '1975-11-25', 'sneha@gmail.com'),
(5, 'Karthik S', '2000-04-10', 'karthik@gmail.com'),
(6, 'Divya Nair', '1968-09-05', 'divya@gmail.com'),
(7, 'Vikram Rao', '1995-12-18', 'vikram@gmail.com'),
(8, 'Meena Devi', '1988-03-22', 'meena@gmail.com');

INSERT INTO Agents VALUES
(1, 'Ramesh Kumar', 'Chennai'),
(2, 'Anita Sharma', 'Bangalore'),
(3, 'Suresh Raj', 'Mumbai'),
(4, 'Kavitha Nair', 'Hyderabad'),
(5, 'Vijay Rao', 'Chennai');

INSERT INTO Products VALUES
(101, 'Health Insurance', 'Health'),
(102, 'Life Insurance', 'Life'),
(103, 'Motor Insurance', 'Motor'),
(104, 'Travel Insurance', 'Travel');

INSERT INTO Policies VALUES
(1001, 'POL100001', 1, 101, 1, '2026-01-01', '2026-12-10', 15000, 'Active'),
(1002, 'POL100002', 2, 102, 2, '2025-06-01', '2026-12-05', 20000, 'Active'),
(1003, 'POL100003', 3, 103, 1, '2026-02-01', '2027-02-01', 12000, 'Active'),
(1004, 'POL100004', 1, 102, 3, '2025-01-01', '2026-11-25', 25000, 'Active'),
(1005, 'POL100005', 4, 101, 2, '2024-01-01', '2025-01-01', 18000, 'Expired'),
(1006, 'POL100006', 5, 103, 4, '2026-03-01', '2027-03-01', 10000, 'Active'),
(1007, 'POL100007', 6, 104, 5, '2026-04-01', '2027-04-01', 8000, 'Active'),
(1008, 'POL100008', 7, 101, 3, '2026-01-15', '2027-01-15', 16000, 'Active'),
(1009, 'POL100009', 8, 102, 4, '2025-05-01', '2026-05-01', 22000, 'Expired'),
(1010, 'POL100010', 2, 103, 1, '2026-05-01', '2027-05-01', 14000, 'Active');

INSERT INTO Premiums VALUES
(1, 1001, '2026-01-01', 15000, 'Paid'),
(2, 1002, '2025-06-01', 20000, 'Paid'),
(3, 1003, '2026-02-01', 12000, 'Paid'),
(4, 1004, '2025-01-01', 25000, 'Paid'),
(5, 1005, '2024-01-01', 18000, 'Paid'),
(6, 1006, '2026-03-01', 10000, 'Paid'),
(7, 1007, '2026-04-01', 8000, 'Paid'),
(8, 1008, '2026-01-15', 16000, 'Paid'),
(9, 1009, '2025-05-01', 22000, 'Paid'),
(10, 1010, '2026-05-01', 14000, 'Pending'),
(11, 1001, '2026-07-01', 15000, 'Paid');

INSERT INTO Claims VALUES
(1, 1001, '2026-03-01', '2026-03-10', 5000, 4500, 'Settled', 'Medical'),
(2, 1002, '2026-04-05', '2026-04-20', 8000, 7500, 'Settled', 'Life'),
(3, 1003, '2026-05-10', NULL, 6000, NULL, 'Pending', 'Accident'),
(4, 1004, '2026-06-01', '2026-06-15', 10000, 9000, 'Settled', 'Life'),
(5, 1006, '2026-07-01', NULL, 3000, NULL, 'Under Review', 'Vehicle'),
(6, 1008, '2026-08-01', '2026-08-12', 4000, 3500, 'Settled', 'Medical'),
(7, 1001, '2026-09-01', '2026-09-05', 2000, 1800, 'Settled', 'Medical'),
(8, 1007, '2026-10-01', NULL, 2500, NULL, 'Pending', 'Travel');
GO

-- =========================================
-- QUERY 1: POLICIES EXPIRING IN NEXT 30 DAYS
-- =========================================

SELECT
    PolicyID,
    PolicyNumber,
    ExpiryDate,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), ExpiryDate) AS DaysRemaining
FROM Policies
WHERE ExpiryDate >= CAST(GETDATE() AS DATE)
  AND ExpiryDate < DATEADD(DAY, 31, CAST(GETDATE() AS DATE))
  AND PolicyStatus = 'Active'
ORDER BY ExpiryDate;
GO

-- =========================================
-- QUERY 2: PREMIUM COLLECTED PER PRODUCT
-- =========================================

SELECT
    PR.ProductName,
    SUM(P.Amount) AS PremiumCollected
FROM Products PR
INNER JOIN Policies PO
    ON PR.ProductID = PO.ProductID
INNER JOIN Premiums P
    ON PO.PolicyID = P.PolicyID
WHERE P.PaymentStatus = 'Paid'
GROUP BY PR.ProductName
ORDER BY PremiumCollected DESC;
GO

-- =========================================
-- QUERY 3: CUSTOMERS WITH MORE THAN ONE ACTIVE POLICY
-- =========================================

SELECT
    C.CustomerID,
    C.CustomerName,
    COUNT(PO.PolicyID) AS ActivePolicyCount
FROM Customers C
INNER JOIN Policies PO
    ON C.CustomerID = PO.CustomerID
WHERE PO.PolicyStatus = 'Active'
GROUP BY C.CustomerID, C.CustomerName
HAVING COUNT(PO.PolicyID) > 1;
GO

-- =========================================
-- QUERY 4: CLAIM RATIO PER PRODUCT
-- =========================================

SELECT
    PR.ProductName,
    SUM(C.ClaimAmount) AS TotalClaimAmount,
    SUM(PO.PremiumAmount) AS TotalPremiumAmount,
    ROUND(
        SUM(C.ClaimAmount) * 100.0 /
        NULLIF(SUM(PO.PremiumAmount), 0), 2
    ) AS ClaimRatioPercentage
FROM Products PR
INNER JOIN Policies PO
    ON PR.ProductID = PO.ProductID
INNER JOIN Claims C
    ON PO.PolicyID = C.PolicyID
GROUP BY PR.ProductName;
GO

-- =========================================
-- QUERY 5: POLICIES WITHOUT CLAIMS
-- =========================================

SELECT
    PO.PolicyID,
    PO.PolicyNumber,
    C.CustomerName
FROM Policies PO
INNER JOIN Customers C
    ON PO.CustomerID = C.CustomerID
LEFT JOIN Claims CL
    ON PO.PolicyID = CL.PolicyID
WHERE CL.ClaimID IS NULL;
GO

-- =========================================
-- QUERY 6: AVERAGE PREMIUM BY AGE BAND
-- =========================================

SELECT
    CASE
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 30
            THEN 'Below 30'
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 45
            THEN '30-44'
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 60
            THEN '45-59'
        ELSE '60 and above'
    END AS AgeBand,
    ROUND(AVG(PO.PremiumAmount), 2) AS AveragePremium
FROM Customers C
INNER JOIN Policies PO
    ON C.CustomerID = PO.CustomerID
GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 30
            THEN 'Below 30'
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 45
            THEN '30-44'
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 60
            THEN '45-59'
        ELSE '60 and above'
    END;
GO

-- =========================================
-- QUERY 7: MONTHLY NEW POLICIES
-- =========================================

SELECT
    FORMAT(StartDate, 'yyyy-MM') AS PolicyMonth,
    COUNT(*) AS NewPolicies
FROM Policies
GROUP BY FORMAT(StartDate, 'yyyy-MM')
ORDER BY PolicyMonth;
GO

-- =========================================
-- QUERY 8: TOP 5 AGENTS BY PREMIUM
-- =========================================

SELECT TOP 5
    A.AgentID,
    A.AgentName,
    SUM(P.Amount) AS TotalPremium
FROM Agents A
INNER JOIN Policies PO
    ON A.AgentID = PO.AgentID
INNER JOIN Premiums P
    ON PO.PolicyID = P.PolicyID
WHERE P.PaymentStatus = 'Paid'
GROUP BY A.AgentID, A.AgentName
ORDER BY TotalPremium DESC;
GO

-- =========================================
-- ADDITIONAL: POLICY AGE AND MASKED POLICY NUMBER
-- =========================================

SELECT
    PolicyID,
    CONCAT(
        LEFT(PolicyNumber, 3),
        '****',
        RIGHT(PolicyNumber, 3)
    ) AS MaskedPolicyNumber,
    DATEDIFF(DAY, StartDate, GETDATE()) AS PolicyAgeDays,
    CASE
        WHEN DATEDIFF(YEAR, StartDate, GETDATE()) < 1
            THEN 'New Policy'
        WHEN DATEDIFF(YEAR, StartDate, GETDATE()) < 3
            THEN '1-2 Years'
        ELSE '3+ Years'
    END AS PolicyAgeBand
FROM Policies;
GO

-- =========================================
-- WHERE VS HAVING DEMONSTRATION
-- =========================================

-- WHERE filters individual rows before grouping.
SELECT
    PolicyStatus,
    COUNT(*) AS PolicyCount
FROM Policies
WHERE PolicyStatus = 'Active'
GROUP BY PolicyStatus;

-- HAVING filters grouped results after aggregation.
SELECT
    CustomerID,
    COUNT(*) AS PolicyCount
FROM Policies
GROUP BY CustomerID
HAVING COUNT(*) > 1;
GO
