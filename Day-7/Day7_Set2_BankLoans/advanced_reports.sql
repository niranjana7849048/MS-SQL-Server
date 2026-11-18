
-- Day 7 - Set 2
-- Bank Loan Portfolio
-- SQL Server 2025
-- Topics: Equi Join, Self Join, Subqueries, EXISTS, NOT EXISTS,
--         Correlated Subqueries, Nested Subqueries

CREATE DATABASE BankLoanReporting;
GO

USE BankLoanReporting;
GO

-- ==========================================
-- 1. DROP EXISTING TABLES
-- ==========================================

DROP TABLE IF EXISTS Repayments;
DROP TABLE IF EXISTS LoanGuarantors;
DROP TABLE IF EXISTS Loans;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Branches;
GO

-- ==========================================
-- 2. CREATE TABLES
-- ==========================================

CREATE TABLE Branches (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    LoanType VARCHAR(50),
    PrincipalAmount DECIMAL(12,2),
    InterestRate DECIMAL(5,2),
    LoanDate DATE,
    LoanStatus VARCHAR(30),
    TotalInstallments INT,
    InstallmentsPaid INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

CREATE TABLE LoanGuarantors (
    LoanID INT,
    GuarantorCustomerID INT,
    PRIMARY KEY (LoanID, GuarantorCustomerID),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID),
    FOREIGN KEY (GuarantorCustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Repayments (
    RepaymentID INT PRIMARY KEY,
    LoanID INT NOT NULL,
    RepaymentDate DATE NOT NULL,
    Amount DECIMAL(12,2),
    PaymentStatus VARCHAR(30),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);
GO

-- ==========================================
-- 3. INSERT BRANCHES
-- ==========================================

INSERT INTO Branches VALUES
(1, 'Chennai Main Branch', 'Chennai'),
(2, 'Bangalore Branch', 'Bangalore'),
(3, 'Coimbatore Branch', 'Coimbatore'),
(4, 'Hyderabad Branch', 'Hyderabad'),
(5, 'Mumbai Branch', 'Mumbai');

-- ==========================================
-- 4. INSERT CUSTOMERS
-- ==========================================

INSERT INTO Customers VALUES
(101, 'Arun Kumar', 'Chennai', 'arun@example.com'),
(102, 'Priya Sharma', 'Bangalore', 'priya@example.com'),
(103, 'Rahul Verma', 'Chennai', 'rahul@example.com'),
(104, 'Sneha Raj', 'Coimbatore', 'sneha@example.com'),
(105, 'Karthik S', 'Bangalore', 'karthik@example.com'),
(106, 'Divya Nair', 'Hyderabad', 'divya@example.com'),
(107, 'Vijay Kumar', 'Mumbai', 'vijay@example.com'),
(108, 'Meena Das', 'Chennai', 'meena@example.com'),
(109, 'Sanjay Rao', 'Coimbatore', 'sanjay@example.com'),
(110, 'Anitha Das', 'Hyderabad', 'anitha@example.com');

-- ==========================================
-- 5. INSERT LOANS
-- ==========================================

INSERT INTO Loans VALUES
(1001, 101, 1, 'Home Loan', 2500000, 8.50, '2025-01-10', 'Active', 120, 110),
(1002, 102, 2, 'Personal Loan', 500000, 11.00, '2025-02-15', 'Active', 36, 20),
(1003, 103, 1, 'Vehicle Loan', 800000, 9.50, '2025-03-20', 'Active', 60, 45),
(1004, 104, 3, 'Home Loan', 3000000, 8.25, '2025-04-05', 'Active', 180, 160),
(1005, 105, 2, 'Education Loan', 600000, 7.50, '2025-05-12', 'Active', 60, 30),
(1006, 101, 2, 'Personal Loan', 400000, 12.00, '2025-06-18', 'Active', 24, 10),
(1007, 106, 4, 'Vehicle Loan', 900000, 9.00, '2025-07-22', 'Active', 48, 25),
(1008, 107, 1, 'Business Loan', 1500000, 10.50, '2025-08-10', 'Active', 60, 35),
(1009, 108, 3, 'Personal Loan', 300000, 12.50, '2025-09-14', 'Active', 24, 8),
(1010, 109, 4, 'Home Loan', 2000000, 8.75, '2025-10-19', 'Active', 120, 80),
(1011, 102, 1, 'Vehicle Loan', 700000, 9.25, '2025-11-25', 'Active', 48, 20),
(1012, 110, 2, 'Education Loan', 450000, 7.25, '2025-12-05', 'Active', 60, 15);

-- ==========================================
-- 6. INSERT LOAN GUARANTORS
-- ==========================================

INSERT INTO LoanGuarantors VALUES
(1001, 102),
(1002, 101),
(1003, 104),
(1004, 105),
(1005, 103),
(1006, 107),
(1007, 101),
(1008, 106),
(1009, 102),
(1010, 108),
(1011, 109),
(1012, 103);

-- ==========================================
-- 7. INSERT REPAYMENTS
-- ==========================================

INSERT INTO Repayments VALUES
(1, 1001, '2026-10-10', 25000, 'Paid'),
(2, 1001, '2026-11-10', 25000, 'Paid'),
(3, 1002, '2026-08-15', 15000, 'Paid'),
(4, 1002, '2026-09-15', 15000, 'Paid'),
(5, 1003, '2026-11-05', 18000, 'Paid'),
(6, 1004, '2026-10-05', 30000, 'Paid'),
(7, 1005, '2026-07-12', 12000, 'Paid'),
(8, 1006, '2026-11-12', 20000, 'Paid'),
(9, 1007, '2026-08-22', 19000, 'Paid'),
(10, 1008, '2026-11-01', 28000, 'Paid'),
(11, 1009, '2026-06-14', 14000, 'Paid'),
(12, 1010, '2026-09-19', 22000, 'Paid'),
(13, 1011, '2026-11-15', 16000, 'Paid'),
(14, 1012, '2026-10-05', 10000, 'Paid'),
(15, 1003, '2026-10-05', 18000, 'Paid'),
(16, 1004, '2026-11-05', 30000, 'Paid'),
(17, 1007, '2026-07-22', 19000, 'Paid'),
(18, 1009, '2026-05-14', 14000, 'Paid');
GO

-- ==========================================
-- REPORT 1
-- Display loan details with customer and branch
-- Equi Join
-- ==========================================

PRINT 'REPORT 1: Loan Details with Customer and Branch';

SELECT
    l.LoanID,
    c.CustomerName,
    b.BranchName,
    l.LoanType,
    l.PrincipalAmount,
    l.InterestRate,
    l.LoanStatus
FROM Loans l
INNER JOIN Customers c
    ON l.CustomerID = c.CustomerID
INNER JOIN Branches b
    ON l.BranchID = b.BranchID
ORDER BY l.LoanID;

-- ==========================================
-- REPORT 2
-- Loans overdue by more than 3 instalments
-- ==========================================

PRINT 'REPORT 2: Loans Overdue by More Than 3 Instalments';

SELECT
    l.LoanID,
    c.CustomerName,
    l.LoanType,
    l.TotalInstallments,
    l.InstallmentsPaid,
    (l.TotalInstallments - l.InstallmentsPaid) AS RemainingInstallments
FROM Loans l
INNER JOIN Customers c
    ON l.CustomerID = c.CustomerID
WHERE (l.TotalInstallments - l.InstallmentsPaid) > 3
ORDER BY RemainingInstallments DESC;

-- Note: This sample uses remaining instalments as a proxy.
-- Actual overdue instalments require a due-date/payment schedule.

-- ==========================================
-- REPORT 3
-- Customers who have loans in more than one branch
-- GROUP BY and HAVING
-- ==========================================

PRINT 'REPORT 3: Customers with Loans in Multiple Branches';

SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(DISTINCT l.BranchID) AS NumberOfBranches
FROM Customers c
INNER JOIN Loans l
    ON c.CustomerID = l.CustomerID
GROUP BY
    c.CustomerID,
    c.CustomerName
HAVING COUNT(DISTINCT l.BranchID) > 1;

-- ==========================================
-- REPORT 4
-- Guarantors who are also borrowers
-- Self-related customer comparison
-- ==========================================

PRINT 'REPORT 4: Guarantors Who Are Also Borrowers';

SELECT DISTINCT
    g.CustomerID AS GuarantorCustomerID,
    g.CustomerName AS GuarantorName,
    borrower.CustomerID AS BorrowerCustomerID,
    borrower.CustomerName AS BorrowerName,
    lg.LoanID AS GuaranteedLoanID
FROM LoanGuarantors lg
INNER JOIN Customers g
    ON lg.GuarantorCustomerID = g.CustomerID
INNER JOIN Loans l
    ON lg.LoanID = l.LoanID
INNER JOIN Customers borrower
    ON l.CustomerID = borrower.CustomerID
WHERE EXISTS (
    SELECT 1
    FROM Loans ownLoan
    WHERE ownLoan.CustomerID = g.CustomerID
);

-- ==========================================
-- REPORT 5
-- Branches with no loans
-- LEFT JOIN
-- ==========================================

PRINT 'REPORT 5: Branches Without Loans';

SELECT
    b.BranchID,
    b.BranchName,
    b.City
FROM Branches b
LEFT JOIN Loans l
    ON b.BranchID = l.BranchID
WHERE l.LoanID IS NULL;

-- ==========================================
-- REPORT 6
-- Total loan exposure by branch
-- Aggregate Functions and Joins
-- ==========================================

PRINT 'REPORT 6: Total Loan Exposure by Branch';

SELECT
    b.BranchID,
    b.BranchName,
    COUNT(l.LoanID) AS TotalLoans,
    COALESCE(SUM(l.PrincipalAmount), 0) AS TotalLoanExposure,
    COALESCE(AVG(l.PrincipalAmount), 0) AS AverageLoanAmount
FROM Branches b
LEFT JOIN Loans l
    ON b.BranchID = l.BranchID
GROUP BY
    b.BranchID,
    b.BranchName
ORDER BY TotalLoanExposure DESC;

-- ==========================================
-- REPORT 7
-- Customers whose total exposure is above
-- their branch's average customer exposure
-- Correlated Subquery
-- ==========================================

PRINT 'REPORT 7: Customers Above Branch Average Exposure';

WITH CustomerBranchExposure AS (
    SELECT
        l.BranchID,
        l.CustomerID,
        SUM(l.PrincipalAmount) AS TotalExposure
    FROM Loans l
    GROUP BY
        l.BranchID,
        l.CustomerID
)
SELECT
    c.CustomerID,
    c.CustomerName,
    b.BranchName,
    x.TotalExposure
FROM CustomerBranchExposure x
INNER JOIN Customers c
    ON x.CustomerID = c.CustomerID
INNER JOIN Branches b
    ON x.BranchID = b.BranchID
WHERE x.TotalExposure > (
    SELECT AVG(x2.TotalExposure)
    FROM CustomerBranchExposure x2
    WHERE x2.BranchID = x.BranchID
)
ORDER BY b.BranchName, x.TotalExposure DESC;

-- ==========================================
-- REPORT 8
-- Loans with no repayment in the last 60 days
-- NOT EXISTS
-- Reference date: 18 November 2026
-- ==========================================

PRINT 'REPORT 8: Loans Without Repayment in Last 60 Days';

SELECT
    l.LoanID,
    c.CustomerName,
    l.LoanType,
    l.PrincipalAmount
FROM Loans l
INNER JOIN Customers c
    ON l.CustomerID = c.CustomerID
WHERE NOT EXISTS (
    SELECT 1
    FROM Repayments r
    WHERE r.LoanID = l.LoanID
      AND r.PaymentStatus = 'Paid'
      AND r.RepaymentDate >= DATEADD(
          DAY,
          -60,
          CAST('2026-11-18' AS DATE)
      )
      AND r.RepaymentDate <= CAST('2026-11-18' AS DATE)
)
ORDER BY l.LoanID;

-- ==========================================
-- REPORT 9
-- Loans that have at least one repayment
-- in the last 60 days
-- EXISTS
-- ==========================================

PRINT 'REPORT 9: Loans with Recent Repayments';

SELECT
    l.LoanID,
    c.CustomerName,
    l.LoanType,
    l.PrincipalAmount
FROM Loans l
INNER JOIN Customers c
    ON l.CustomerID = c.CustomerID
WHERE EXISTS (
    SELECT 1
    FROM Repayments r
    WHERE r.LoanID = l.LoanID
      AND r.PaymentStatus = 'Paid'
      AND r.RepaymentDate >= DATEADD(
          DAY,
          -60,
          CAST('2026-11-18' AS DATE)
      )
      AND r.RepaymentDate <= CAST('2026-11-18' AS DATE)
)
ORDER BY l.LoanID;

-- ==========================================
-- REPORT 10
-- Branches whose highest loan amount is
-- above the bank-wide average of branch maxima
-- Nested Subquery
-- ==========================================

PRINT 'REPORT 10: Branches Above Bank-Wide Average Branch Maximum';

SELECT
    b.BranchID,
    b.BranchName,
    MAX(l.PrincipalAmount) AS HighestLoanAmount
FROM Branches b
INNER JOIN Loans l
    ON b.BranchID = l.BranchID
GROUP BY
    b.BranchID,
    b.BranchName
HAVING MAX(l.PrincipalAmount) > (
    SELECT AVG(BranchMaximum)
    FROM (
        SELECT
            MAX(l2.PrincipalAmount) AS BranchMaximum
        FROM Loans l2
        GROUP BY l2.BranchID
    ) AS BranchMaxima
)
ORDER BY HighestLoanAmount DESC;

-- ==========================================
-- EXTRA REPORT 11
-- Total repayment amount per loan
-- ==========================================

PRINT 'EXTRA REPORT 11: Total Repayment by Loan';

SELECT
    l.LoanID,
    c.CustomerName,
    l.PrincipalAmount,
    COALESCE(SUM(r.Amount), 0) AS TotalRepaid
FROM Loans l
INNER JOIN Customers c
    ON l.CustomerID = c.CustomerID
LEFT JOIN Repayments r
    ON l.LoanID = r.LoanID
    AND r.PaymentStatus = 'Paid'
GROUP BY
    l.LoanID,
    c.CustomerName,
    l.PrincipalAmount
ORDER BY l.LoanID;

-- ==========================================
-- EXTRA REPORT 12
-- Find loans above the average loan amount
-- using an uncorrelated subquery
-- ==========================================

PRINT 'EXTRA REPORT 12: Loans Above Overall Average';

SELECT
    LoanID,
    LoanType,
    PrincipalAmount
FROM Loans
WHERE PrincipalAmount > (
    SELECT AVG(PrincipalAmount)
    FROM Loans
)
ORDER BY PrincipalAmount DESC;

-- ==========================================
-- FINAL TABLE COUNTS
-- ==========================================

PRINT 'FINAL TABLE COUNTS';

SELECT 'Branches' AS TableName, COUNT(*) AS TotalRecords
FROM Branches
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Loans', COUNT(*) FROM Loans
UNION ALL
SELECT 'LoanGuarantors', COUNT(*) FROM LoanGuarantors
UNION ALL
SELECT 'Repayments', COUNT(*) FROM Repayments;
GO
