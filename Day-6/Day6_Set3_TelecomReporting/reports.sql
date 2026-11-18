
/*
Day 6 - Set 3: Telecom Usage and Billing Reporting
Database: TelecomReporting
SQL Server 2025

Reports:
1. Total call minutes per plan
2. Subscribers exceeding their monthly data limit
3. Month-wise revenue
4. Invoices overdue by more than 15 days
5. Subscribers with no usage
6. ARPU by circle
7. Plan popularity
8. Top 10 data consumers

Additional demonstrations:
- String and date functions
- NULL behaviour with SUM() and AVG()
*/

------------------------------------------------------------
-- 1. CREATE DATABASE
------------------------------------------------------------

IF DB_ID('TelecomReporting') IS NULL
    CREATE DATABASE TelecomReporting;
GO

USE TelecomReporting;
GO

------------------------------------------------------------
-- 2. DROP EXISTING TABLES (FOR SAFE RE-EXECUTION)
------------------------------------------------------------

DROP TABLE IF EXISTS UsageRecords;
DROP TABLE IF EXISTS Invoices;
DROP TABLE IF EXISTS Subscribers;
DROP TABLE IF EXISTS Plans;
GO

------------------------------------------------------------
-- 3. CREATE TABLES
------------------------------------------------------------

CREATE TABLE Plans (
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(50) NOT NULL,
    MonthlyRental DECIMAL(10,2) NOT NULL,
    DataLimitGB DECIMAL(8,2) NOT NULL,
    VoiceLimitMinutes INT NOT NULL
);
GO

CREATE TABLE Subscribers (
    SubscriberID INT PRIMARY KEY,
    SubscriberName VARCHAR(100) NOT NULL,
    MobileNumber VARCHAR(15) UNIQUE NOT NULL,
    Circle VARCHAR(50) NOT NULL,
    PlanID INT NOT NULL,
    ActivationDate DATE NOT NULL,
    SubscriberStatus VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Subscribers_Plans
        FOREIGN KEY (PlanID) REFERENCES Plans(PlanID),

    CONSTRAINT CK_Subscriber_Status
        CHECK (SubscriberStatus IN ('Active', 'Inactive'))
);
GO

CREATE TABLE UsageRecords (
    UsageID INT PRIMARY KEY,
    SubscriberID INT NOT NULL,
    UsageDate DATE NOT NULL,
    CallMinutes INT NULL,
    DataUsedGB DECIMAL(8,2) NULL,
    SMSCount INT NULL,

    CONSTRAINT FK_Usage_Subscribers
        FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID)
);
GO

CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    SubscriberID INT NOT NULL,
    InvoiceDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    InvoiceAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL,
    PaymentDate DATE NULL,

    CONSTRAINT FK_Invoices_Subscribers
        FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID),

    CONSTRAINT CK_Invoice_Status
        CHECK (PaymentStatus IN ('Paid', 'Unpaid', 'Pending'))
);
GO

------------------------------------------------------------
-- 4. INSERT PLAN DATA
------------------------------------------------------------

INSERT INTO Plans
    (PlanID, PlanName, MonthlyRental, DataLimitGB, VoiceLimitMinutes)
VALUES
    (1, 'Basic Plan', 199.00, 2.00, 300),
    (2, 'Smart Plan', 399.00, 5.00, 600),
    (3, 'Premium Plan', 599.00, 10.00, 1200),
    (4, 'Unlimited Plan', 999.00, 30.00, 3000);
GO

------------------------------------------------------------
-- 5. INSERT SUBSCRIBER DATA
------------------------------------------------------------

INSERT INTO Subscribers
    (SubscriberID, SubscriberName, MobileNumber, Circle,
     PlanID, ActivationDate, SubscriberStatus)
VALUES
    (101, 'Arun Kumar',    '9876500001', 'Chennai',   1, '2025-01-10', 'Active'),
    (102, 'Priya Sharma',  '9876500002', 'Bangalore', 2, '2025-03-15', 'Active'),
    (103, 'Rahul Verma',   '9876500003', 'Chennai',   3, '2025-05-20', 'Active'),
    (104, 'Sneha Reddy',   '9876500004', 'Hyderabad', 2, '2025-07-12', 'Active'),
    (105, 'Karthik Raj',   '9876500005', 'Chennai',   4, '2025-09-01', 'Active'),
    (106, 'Meena Iyer',    '9876500006', 'Bangalore', 1, '2025-11-18', 'Active'),
    (107, 'Vijay Kumar',   '9876500007', 'Hyderabad', 3, '2026-01-05', 'Active'),
    (108, 'Divya Nair',    '9876500008', 'Mumbai',    2, '2026-02-14', 'Active'),
    (109, 'Sanjay Rao',    '9876500009', 'Mumbai',    4, '2026-04-22', 'Inactive'),
    (110, 'Anitha Das',    '9876500010', 'Bangalore', 1, '2026-06-30', 'Active');
GO

------------------------------------------------------------
-- 6. INSERT USAGE RECORDS
-- Usage records are from November 2026.
------------------------------------------------------------

INSERT INTO UsageRecords
    (UsageID, SubscriberID, UsageDate, CallMinutes, DataUsedGB, SMSCount)
VALUES
    (1,  101, '2026-11-01', 120, 1.20, 30),
    (2,  101, '2026-11-10',  90, 1.10, 20),

    (3,  102, '2026-11-02', 250, 3.00, 45),
    (4,  102, '2026-11-12', 200, 2.50, 35),

    (5,  103, '2026-11-03', 400, 6.00, 60),
    (6,  103, '2026-11-13', 350, 5.50, 55),

    (7,  104, '2026-11-04', 180, 2.00, 25),
    (8,  104, '2026-11-14', 160, 2.20, 30),

    (9,  105, '2026-11-05', 600, 12.00, 100),
    (10, 105, '2026-11-15', 550, 11.00, 90),

    (11, 106, '2026-11-06', 100, 0.80, 15),
    (12, 106, '2026-11-16',  80, 0.70, 10),

    (13, 107, '2026-11-07', 500, 4.50, 70),
    (14, 107, '2026-11-17', 450, 4.00, 65),

    (15, 108, '2026-11-08', 220, 3.20, 40),
    (16, 108, '2026-11-17', 180, 2.50, 35),

    (17, 109, '2026-11-09', 700, 18.00, 120),
    (18, 109, '2026-11-17', 650, 15.00, 110);
GO

------------------------------------------------------------
-- 7. INSERT INVOICE DATA
------------------------------------------------------------

INSERT INTO Invoices
    (InvoiceID, SubscriberID, InvoiceDate, DueDate,
     InvoiceAmount, PaymentStatus, PaymentDate)
VALUES
    (5001, 101, '2026-01-05', '2026-01-20', 199.00, 'Paid',   '2026-01-15'),
    (5002, 102, '2026-01-05', '2026-01-20', 399.00, 'Paid',   '2026-01-18'),
    (5003, 103, '2026-02-05', '2026-02-20', 599.00, 'Paid',   '2026-02-15'),
    (5004, 104, '2026-02-05', '2026-02-20', 399.00, 'Paid',   '2026-02-19'),
    (5005, 105, '2026-03-05', '2026-03-20', 999.00, 'Paid',   '2026-03-17'),
    (5006, 106, '2026-03-05', '2026-03-20', 199.00, 'Unpaid', NULL),
    (5007, 107, '2026-04-05', '2026-04-20', 599.00, 'Paid',   '2026-04-18'),
    (5008, 108, '2026-04-05', '2026-04-20', 399.00, 'Unpaid', NULL),
    (5009, 109, '2026-05-05', '2026-05-20', 999.00, 'Pending', NULL),
    (5010, 110, '2026-05-05', '2026-05-20', 199.00, 'Paid',   '2026-05-19'),
    (5011, 101, '2026-11-01', '2026-11-10', 199.00, 'Unpaid', NULL),
    (5012, 103, '2026-11-01', '2026-11-10', 599.00, 'Paid',   '2026-11-08');
GO

------------------------------------------------------------
-- 8. REPORT 1: TOTAL CALL MINUTES PER PLAN
------------------------------------------------------------

PRINT 'REPORT 1: TOTAL CALL MINUTES PER PLAN';

SELECT
    P.PlanName,
    SUM(U.CallMinutes) AS TotalCallMinutes
FROM Plans P
INNER JOIN Subscribers S
    ON P.PlanID = S.PlanID
INNER JOIN UsageRecords U
    ON S.SubscriberID = U.SubscriberID
GROUP BY P.PlanName
ORDER BY TotalCallMinutes DESC;
GO

------------------------------------------------------------
-- 9. REPORT 2: SUBSCRIBERS EXCEEDING DATA LIMIT
-- Data usage is compared with the monthly plan limit.
------------------------------------------------------------

PRINT 'REPORT 2: SUBSCRIBERS EXCEEDING DATA LIMIT';

SELECT
    S.SubscriberID,
    S.SubscriberName,
    P.PlanName,
    P.DataLimitGB,
    SUM(U.DataUsedGB) AS TotalDataUsedGB,
    ROUND(SUM(U.DataUsedGB) - P.DataLimitGB, 2) AS ExcessDataGB
FROM Subscribers S
INNER JOIN Plans P
    ON S.PlanID = P.PlanID
INNER JOIN UsageRecords U
    ON S.SubscriberID = U.SubscriberID
WHERE U.UsageDate >= '2026-11-01'
  AND U.UsageDate < '2026-12-01'
GROUP BY
    S.SubscriberID,
    S.SubscriberName,
    P.PlanName,
    P.DataLimitGB
HAVING SUM(U.DataUsedGB) > P.DataLimitGB
ORDER BY ExcessDataGB DESC;
GO

------------------------------------------------------------
-- 10. REPORT 3: MONTH-WISE REVENUE
-- Only successfully paid invoices are included.
------------------------------------------------------------

PRINT 'REPORT 3: MONTH-WISE REVENUE';

SELECT
    FORMAT(InvoiceDate, 'yyyy-MM') AS InvoiceMonth,
    SUM(InvoiceAmount) AS TotalRevenue
FROM Invoices
WHERE PaymentStatus = 'Paid'
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY InvoiceMonth;
GO

------------------------------------------------------------
-- 11. REPORT 4: INVOICES OVERDUE BY MORE THAN 15 DAYS
------------------------------------------------------------

PRINT 'REPORT 4: INVOICES OVERDUE BY MORE THAN 15 DAYS';

SELECT
    I.InvoiceID,
    CONCAT('INV-', RIGHT(CONCAT('000000', I.InvoiceID), 6))
        AS FormattedInvoiceNumber,
    S.SubscriberName,
    FORMAT(I.DueDate, 'dd-MMM-yyyy') AS DueDate,
    DATEDIFF(DAY, I.DueDate, CAST(GETDATE() AS DATE))
        AS DaysOverdue,
    CASE
        WHEN I.PaymentStatus = 'Paid' THEN 'Paid'
        WHEN DATEDIFF(DAY, I.DueDate, CAST(GETDATE() AS DATE)) > 15
            THEN 'Overdue'
        ELSE 'Not Overdue'
    END AS DueStatus,
    I.InvoiceAmount
FROM Invoices I
INNER JOIN Subscribers S
    ON I.SubscriberID = S.SubscriberID
WHERE I.PaymentStatus IN ('Unpaid', 'Pending')
  AND I.DueDate < DATEADD(DAY, -15, CAST(GETDATE() AS DATE))
ORDER BY I.DueDate;
GO

------------------------------------------------------------
-- 12. REPORT 5: SUBSCRIBERS WITH NO USAGE
------------------------------------------------------------

PRINT 'REPORT 5: SUBSCRIBERS WITH NO USAGE';

SELECT
    S.SubscriberID,
    S.SubscriberName,
    S.Circle,
    P.PlanName
FROM Subscribers S
INNER JOIN Plans P
    ON S.PlanID = P.PlanID
LEFT JOIN UsageRecords U
    ON S.SubscriberID = U.SubscriberID
WHERE U.UsageID IS NULL
ORDER BY S.SubscriberID;
GO

------------------------------------------------------------
-- 13. REPORT 6: ARPU BY CIRCLE
-- ARPU = Total paid invoice revenue / subscriber count.
------------------------------------------------------------

PRINT 'REPORT 6: ARPU BY CIRCLE';

SELECT
    S.Circle,
    COUNT(DISTINCT S.SubscriberID) AS SubscriberCount,
    SUM(CASE
        WHEN I.PaymentStatus = 'Paid' THEN I.InvoiceAmount
        ELSE 0
    END) AS TotalPaidRevenue,
    ROUND(
        SUM(CASE
            WHEN I.PaymentStatus = 'Paid' THEN I.InvoiceAmount
            ELSE 0
        END) * 1.0 / COUNT(DISTINCT S.SubscriberID),
        2
    ) AS ARPU
FROM Subscribers S
LEFT JOIN Invoices I
    ON S.SubscriberID = I.SubscriberID
GROUP BY S.Circle
ORDER BY ARPU DESC;
GO

------------------------------------------------------------
-- 14. REPORT 7: PLAN POPULARITY
------------------------------------------------------------

PRINT 'REPORT 7: PLAN POPULARITY';

SELECT
    P.PlanName,
    COUNT(S.SubscriberID) AS SubscriberCount,
    CONCAT(
        CAST(
            ROUND(
                COUNT(S.SubscriberID) * 100.0 /
                (SELECT COUNT(*) FROM Subscribers),
                2
            ) AS VARCHAR(10)
        ),
        '%'
    ) AS SubscriberPercentage
FROM Plans P
LEFT JOIN Subscribers S
    ON P.PlanID = S.PlanID
GROUP BY P.PlanID, P.PlanName
ORDER BY SubscriberCount DESC;
GO

------------------------------------------------------------
-- 15. REPORT 8: TOP 10 DATA CONSUMERS
------------------------------------------------------------

PRINT 'REPORT 8: TOP 10 DATA CONSUMERS';

SELECT TOP 10
    S.SubscriberID,
    UPPER(S.SubscriberName) AS SubscriberName,
    S.Circle,
    SUM(U.DataUsedGB) AS TotalDataUsedGB,
    COUNT(U.UsageID) AS UsageSessions
FROM Subscribers S
INNER JOIN UsageRecords U
    ON S.SubscriberID = U.SubscriberID
WHERE U.UsageDate >= '2026-11-01'
  AND U.UsageDate < '2026-12-01'
GROUP BY
    S.SubscriberID,
    S.SubscriberName,
    S.Circle
ORDER BY TotalDataUsedGB DESC;
GO

------------------------------------------------------------
-- 16. NULL BEHAVIOUR WITH SUM() AND AVG()
-- LEFT JOIN includes subscribers without usage records.
------------------------------------------------------------

PRINT 'NULL BEHAVIOUR: SUM AND AVG';

SELECT
    S.SubscriberID,
    S.SubscriberName,
    COUNT(*) AS JoinedRows,
    COUNT(U.DataUsedGB) AS NonNullUsageRows,
    SUM(U.DataUsedGB) AS TotalDataUsedGB,
    AVG(U.DataUsedGB) AS AverageDataUsedGB
FROM Subscribers S
LEFT JOIN UsageRecords U
    ON S.SubscriberID = U.SubscriberID
GROUP BY
    S.SubscriberID,
    S.SubscriberName
ORDER BY S.SubscriberID;
GO

------------------------------------------------------------
-- 17. GENERAL NULL AGGREGATION DEMONSTRATION
------------------------------------------------------------

PRINT 'GENERAL NULL AGGREGATION EXAMPLE';

SELECT
    COUNT(*) AS TotalRows,
    COUNT(DataValue) AS NonNullRows,
    SUM(DataValue) AS SumValue,
    AVG(DataValue) AS AverageValue
FROM (VALUES
    (10),
    (20),
    (NULL),
    (30)
) AS SampleData(DataValue);
GO


