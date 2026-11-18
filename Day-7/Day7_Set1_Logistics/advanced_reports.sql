
/*
DAY 7 - SET 1: LOGISTICS SHIPMENT ANALYSIS
SQL Server 2025

Topics:
1. INNER JOIN
2. LEFT JOIN
3. FULL OUTER JOIN
4. SELF JOIN
5. IN, EXISTS, ANY and ALL
6. Correlated subqueries
7. Nested subqueries
8. Rewriting subqueries as joins
9. Second-highest shipping cost per hub
*/

------------------------------------------------------------
-- 1. CREATE DATABASE
------------------------------------------------------------

IF DB_ID('LogisticsReporting') IS NULL
    CREATE DATABASE LogisticsReporting;
GO

USE LogisticsReporting;
GO

------------------------------------------------------------
-- 2. DROP EXISTING TABLES
------------------------------------------------------------

DROP TABLE IF EXISTS DeliveryEvents;
DROP TABLE IF EXISTS Shipments;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Carriers;
DROP TABLE IF EXISTS Hubs;
GO

------------------------------------------------------------
-- 3. CREATE TABLES
------------------------------------------------------------

CREATE TABLE Hubs (
    HubID INT PRIMARY KEY,
    HubName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Carriers (
    CarrierID INT PRIMARY KEY,
    CarrierName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15)
);
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);
GO

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Designation VARCHAR(50),
    SupervisorID INT NULL,

    CONSTRAINT FK_Employees_Supervisor
        FOREIGN KEY (SupervisorID)
        REFERENCES Employees(EmployeeID)
);
GO

CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY,
    TrackingNumber VARCHAR(30) UNIQUE NOT NULL,
    CustomerID INT NOT NULL,
    CarrierID INT NOT NULL,
    OriginHubID INT NOT NULL,
    DestinationHubID INT NOT NULL,
    ShippingDate DATE NOT NULL,
    ExpectedDeliveryDate DATE NOT NULL,
    ActualDeliveryDate DATE NULL,
    ShippingCost DECIMAL(10,2) NOT NULL,
    ShipmentStatus VARCHAR(30) NOT NULL,

    CONSTRAINT FK_Shipments_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),

    CONSTRAINT FK_Shipments_Carriers
        FOREIGN KEY (CarrierID) REFERENCES Carriers(CarrierID),

    CONSTRAINT FK_Shipments_OriginHub
        FOREIGN KEY (OriginHubID) REFERENCES Hubs(HubID),

    CONSTRAINT FK_Shipments_DestinationHub
        FOREIGN KEY (DestinationHubID) REFERENCES Hubs(HubID),

    CONSTRAINT CK_Shipment_Status
        CHECK (ShipmentStatus IN ('Delivered', 'In Transit', 'Delayed'))
);
GO

CREATE TABLE DeliveryEvents (
    EventID INT PRIMARY KEY,
    ShipmentID INT NOT NULL,
    EventType VARCHAR(50) NOT NULL,
    EventLocation VARCHAR(100),
    EventDateTime DATETIME2 NOT NULL,
    EventDescription VARCHAR(250),

    CONSTRAINT FK_DeliveryEvents_Shipments
        FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID)
);
GO

------------------------------------------------------------
-- 4. INSERT HUB DATA
------------------------------------------------------------

INSERT INTO Hubs (HubID, HubName, City)
VALUES
(1, 'Chennai Central Hub', 'Chennai'),
(2, 'Bangalore Distribution Hub', 'Bangalore'),
(3, 'Hyderabad Logistics Hub', 'Hyderabad'),
(4, 'Mumbai Delivery Hub', 'Mumbai');
GO

------------------------------------------------------------
-- 5. INSERT CARRIER DATA
------------------------------------------------------------

INSERT INTO Carriers (CarrierID, CarrierName, ContactNumber)
VALUES
(1, 'FastTrack Logistics', '9876501001'),
(2, 'BlueLine Express', '9876501002'),
(3, 'Global Cargo Services', '9876501003');
GO

------------------------------------------------------------
-- 6. INSERT CUSTOMER DATA
------------------------------------------------------------

INSERT INTO Customers (CustomerID, CustomerName, City, Email)
VALUES
(1, 'Arun Kumar', 'Chennai', 'arun@example.com'),
(2, 'Priya Sharma', 'Bangalore', 'priya@example.com'),
(3, 'Rahul Verma', 'Hyderabad', 'rahul@example.com'),
(4, 'Sneha Reddy', 'Chennai', 'sneha@example.com'),
(5, 'Karthik Raj', 'Mumbai', 'karthik@example.com');
GO

------------------------------------------------------------
-- 7. INSERT EMPLOYEE DATA
------------------------------------------------------------

INSERT INTO Employees
    (EmployeeID, EmployeeName, Designation, SupervisorID)
VALUES
(101, 'Ramesh Kumar', 'Operations Manager', NULL),
(102, 'Anita Sharma', 'Hub Supervisor', 101),
(103, 'Vijay Raj', 'Delivery Coordinator', 102),
(104, 'Meena Iyer', 'Logistics Executive', 102),
(105, 'Suresh Nair', 'Hub Supervisor', 101),
(106, 'Divya Das', 'Delivery Coordinator', 105);
GO

------------------------------------------------------------
-- 8. INSERT SHIPMENT DATA
------------------------------------------------------------

INSERT INTO Shipments
(
    ShipmentID, TrackingNumber, CustomerID, CarrierID,
    OriginHubID, DestinationHubID, ShippingDate,
    ExpectedDeliveryDate, ActualDeliveryDate,
    ShippingCost, ShipmentStatus
)
VALUES
(1, 'TRK1001', 1, 1, 1, 2, '2026-01-05', '2026-01-10', '2026-01-13', 1200, 'Delayed'),
(2, 'TRK1002', 2, 2, 1, 3, '2026-01-07', '2026-01-12', '2026-01-12', 1500, 'Delivered'),
(3, 'TRK1003', 1, 1, 2, 1, '2026-01-10', '2026-01-15', '2026-01-19', 900, 'Delayed'),
(4, 'TRK1004', 3, 3, 2, 3, '2026-01-15', '2026-01-20', '2026-01-24', 1800, 'Delayed'),
(5, 'TRK1005', 4, 2, 3, 1, '2026-01-17', '2026-01-22', '2026-01-25', 1100, 'Delayed'),
(6, 'TRK1006', 2, 1, 3, 2, '2026-01-20', '2026-01-25', '2026-01-26', 1300, 'Delivered'),
(7, 'TRK1007', 5, 3, 1, 2, '2026-01-27', '2026-02-01', '2026-02-01', 800, 'Delivered'),
(8, 'TRK1008', 1, 2, 2, 3, '2026-01-31', '2026-02-05', '2026-02-09', 1600, 'Delayed'),
(9, 'TRK1009', 3, 3, 3, 1, '2026-02-05', '2026-02-10', '2026-02-12', 1400, 'Delivered'),
(10, 'TRK1010', 4, 1, 1, 3, '2026-02-07', '2026-02-12', '2026-02-16', 1700, 'Delayed'),
(11, 'TRK1011', 5, 2, 2, 1, '2026-02-10', '2026-02-15', '2026-02-16', 1000, 'Delivered'),
(12, 'TRK1012', 2, 1, 3, 2, '2026-02-15', '2026-02-20', '2026-02-24', 1250, 'Delayed'),
(13, 'TRK1013', 1, 3, 1, 4, '2026-02-18', '2026-02-23', '2026-02-24', 1900, 'Delivered'),
(14, 'TRK1014', 3, 2, 2, 4, '2026-02-20', '2026-02-25', '2026-03-01', 2100, 'Delayed'),
(15, 'TRK1015', 4, 1, 3, 4, '2026-02-22', '2026-02-27', '2026-02-27', 1600, 'Delivered'),
(16, 'TRK1016', 1, 2, 2, 1, '2026-02-24', '2026-03-01', '2026-03-01', 1450, 'Delivered');
GO

------------------------------------------------------------
-- 9. INSERT DELIVERY EVENT DATA
------------------------------------------------------------

INSERT INTO DeliveryEvents
(
    EventID, ShipmentID, EventType,
    EventLocation, EventDateTime, EventDescription
)
VALUES
(1, 1, 'Picked Up', 'Chennai', '2026-01-05 09:00', 'Shipment collected'),
(2, 1, 'In Transit', 'Bangalore', '2026-01-08 14:00', 'Shipment reached transit hub'),
(3, 1, 'Delivered', 'Bangalore', '2026-01-13 11:00', 'Shipment delivered late'),
(4, 2, 'Picked Up', 'Chennai', '2026-01-07 10:00', 'Shipment collected'),
(5, 2, 'Delivered', 'Hyderabad', '2026-01-12 12:00', 'Shipment delivered'),
(6, 3, 'Picked Up', 'Bangalore', '2026-01-10 08:00', 'Shipment collected'),
(7, 3, 'Delivered', 'Chennai', '2026-01-19 16:00', 'Shipment delivered late'),
(8, 4, 'Picked Up', 'Bangalore', '2026-01-15 09:00', 'Shipment collected'),
(9, 4, 'Delivered', 'Hyderabad', '2026-01-24 15:00', 'Shipment delivered late'),
(10, 5, 'Picked Up', 'Hyderabad', '2026-01-17 11:00', 'Shipment collected'),
(11, 5, 'Delivered', 'Chennai', '2026-01-25 10:00', 'Shipment delivered late'),
(12, 6, 'Picked Up', 'Hyderabad', '2026-01-20 09:00', 'Shipment collected'),
(13, 6, 'Delivered', 'Bangalore', '2026-01-26 13:00', 'Shipment delivered'),
(14, 8, 'Picked Up', 'Bangalore', '2026-01-31 10:00', 'Shipment collected'),
(15, 8, 'Delivered', 'Hyderabad', '2026-02-09 14:00', 'Shipment delivered late'),
(16, 10, 'Picked Up', 'Chennai', '2026-02-07 08:00', 'Shipment collected'),
(17, 10, 'Delivered', 'Hyderabad', '2026-02-16 12:00', 'Shipment delivered late'),
(18, 13, 'Picked Up', 'Chennai', '2026-02-18 09:00', 'Shipment collected'),
(19, 13, 'Delivered', 'Mumbai', '2026-02-24 15:00', 'Shipment delivered'),
(20, 14, 'Picked Up', 'Bangalore', '2026-02-20 10:00', 'Shipment collected'),
(21, 14, 'Delivered', 'Mumbai', '2026-03-01 11:00', 'Shipment delivered late');
GO

------------------------------------------------------------
-- REPORT 1: DELAYED SHIPMENTS WITH CARRIER NAMES
-- Join: INNER JOIN
------------------------------------------------------------

PRINT 'REPORT 1: DELAYED SHIPMENTS WITH CARRIER NAMES';

SELECT
    S.ShipmentID,
    S.TrackingNumber,
    C.CarrierName,
    DATEDIFF(
        DAY,
        S.ExpectedDeliveryDate,
        S.ActualDeliveryDate
    ) AS DelayDays
FROM Shipments S
INNER JOIN Carriers C
    ON S.CarrierID = C.CarrierID
WHERE S.ActualDeliveryDate IS NOT NULL
  AND DATEDIFF(
        DAY,
        S.ExpectedDeliveryDate,
        S.ActualDeliveryDate
      ) > 2
ORDER BY DelayDays DESC;
GO

------------------------------------------------------------
-- REPORT 2: HUBS WITH NO OUTBOUND SHIPMENTS
-- Join: LEFT JOIN
------------------------------------------------------------

PRINT 'REPORT 2: HUBS WITH NO OUTBOUND SHIPMENTS';

SELECT
    H.HubID,
    H.HubName,
    H.City
FROM Hubs H
LEFT JOIN Shipments S
    ON H.HubID = S.OriginHubID
WHERE S.ShipmentID IS NULL;
GO

------------------------------------------------------------
-- REPORT 3: EMPLOYEES WITH THEIR SUPERVISORS
-- Join: SELF JOIN
------------------------------------------------------------

PRINT 'REPORT 3: EMPLOYEES WITH THEIR SUPERVISORS';

SELECT
    E.EmployeeID,
    E.EmployeeName AS Employee,
    E.Designation,
    M.EmployeeName AS Supervisor
FROM Employees E
LEFT JOIN Employees M
    ON E.SupervisorID = M.EmployeeID
ORDER BY E.EmployeeID;
GO

------------------------------------------------------------
-- REPORT 4: SHIPMENT DETAILS WITH CUSTOMER,
-- CARRIER AND HUB INFORMATION
-- Join: Multiple INNER JOINS
------------------------------------------------------------

PRINT 'REPORT 4: COMPLETE SHIPMENT DETAILS';

SELECT
    S.TrackingNumber,
    CU.CustomerName,
    C.CarrierName,
    H1.HubName AS OriginHub,
    H2.HubName AS DestinationHub,
    S.ShippingCost,
    S.ShipmentStatus
FROM Shipments S
INNER JOIN Customers CU
    ON S.CustomerID = CU.CustomerID
INNER JOIN Carriers C
    ON S.CarrierID = C.CarrierID
INNER JOIN Hubs H1
    ON S.OriginHubID = H1.HubID
INNER JOIN Hubs H2
    ON S.DestinationHubID = H2.HubID
ORDER BY S.ShipmentID;
GO

------------------------------------------------------------
-- REPORT 5: SHIPMENTS WITHOUT DELIVERY EVENTS
-- Join: LEFT JOIN
------------------------------------------------------------

PRINT 'REPORT 5: SHIPMENTS WITHOUT DELIVERY EVENTS';

SELECT
    S.ShipmentID,
    S.TrackingNumber,
    S.ShipmentStatus
FROM Shipments S
LEFT JOIN DeliveryEvents D
    ON S.ShipmentID = D.ShipmentID
WHERE D.EventID IS NULL;
GO

------------------------------------------------------------
-- REPORT 6: SHIPMENTS AND DELIVERY EVENTS
-- Join: FULL OUTER JOIN
------------------------------------------------------------

PRINT 'REPORT 6: SHIPMENTS AND DELIVERY EVENTS';

SELECT
    S.ShipmentID,
    S.TrackingNumber,
    D.EventID,
    D.EventType,
    D.EventLocation,
    D.EventDateTime
FROM Shipments S
FULL OUTER JOIN DeliveryEvents D
    ON S.ShipmentID = D.ShipmentID
ORDER BY S.ShipmentID, D.EventDateTime;
GO

------------------------------------------------------------
-- REPORT 7: CUSTOMER SHIPMENT COUNT BY CARRIER
-- Join: INNER JOIN
------------------------------------------------------------

PRINT 'REPORT 7: CUSTOMER SHIPMENT COUNT BY CARRIER';

SELECT
    CU.CustomerName,
    C.CarrierName,
    COUNT(S.ShipmentID) AS TotalShipments
FROM Customers CU
INNER JOIN Shipments S
    ON CU.CustomerID = S.CustomerID
INNER JOIN Carriers C
    ON S.CarrierID = C.CarrierID
GROUP BY CU.CustomerName, C.CarrierName
ORDER BY CU.CustomerName, TotalShipments DESC;
GO

------------------------------------------------------------
-- REPORT 8: CARRIERS WITH NO SHIPMENTS
-- Join: LEFT JOIN
------------------------------------------------------------

PRINT 'REPORT 8: CARRIERS WITH NO SHIPMENTS';

SELECT
    C.CarrierID,
    C.CarrierName
FROM Carriers C
LEFT JOIN Shipments S
    ON C.CarrierID = S.CarrierID
WHERE S.ShipmentID IS NULL;
GO

------------------------------------------------------------
-- REPORT 9: DELIVERY EVENT DETAILS WITH SHIPMENT
-- Join: INNER JOIN
------------------------------------------------------------

PRINT 'REPORT 9: DELIVERY EVENTS WITH SHIPMENT DETAILS';

SELECT
    D.EventID,
    S.TrackingNumber,
    CU.CustomerName,
    D.EventType,
    D.EventLocation,
    D.EventDateTime
FROM DeliveryEvents D
INNER JOIN Shipments S
    ON D.ShipmentID = S.ShipmentID
INNER JOIN Customers CU
    ON S.CustomerID = CU.CustomerID
ORDER BY D.EventDateTime;
GO

------------------------------------------------------------
-- REPORT 10: OUTBOUND SHIPMENT COUNT PER HUB
-- Join: LEFT JOIN
------------------------------------------------------------

PRINT 'REPORT 10: OUTBOUND SHIPMENT COUNT PER HUB';

SELECT
    H.HubName,
    COUNT(S.ShipmentID) AS OutboundShipmentCount
FROM Hubs H
LEFT JOIN Shipments S
    ON H.HubID = S.OriginHubID
GROUP BY H.HubID, H.HubName
ORDER BY OutboundShipmentCount DESC;
GO

------------------------------------------------------------
-- SUBQUERY 1: CUSTOMERS WHO SHIPPED TO EVERY HUB
-- Uses NOT EXISTS with a nested NOT EXISTS.
------------------------------------------------------------

PRINT 'SUBQUERY: CUSTOMERS WHO SHIPPED TO EVERY HUB';

SELECT
    CU.CustomerID,
    CU.CustomerName
FROM Customers CU
WHERE NOT EXISTS (
    SELECT 1
    FROM Hubs H
    WHERE NOT EXISTS (
        SELECT 1
        FROM Shipments S
        WHERE S.CustomerID = CU.CustomerID
          AND S.DestinationHubID = H.HubID
    )
);
GO

------------------------------------------------------------
-- SUBQUERY 2: IN
-- Customers who shipped to Mumbai Hub.
------------------------------------------------------------

PRINT 'SUBQUERY: IN';

SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Shipments
    WHERE DestinationHubID = 4
);
GO

------------------------------------------------------------
-- SUBQUERY 3: EXISTS
-- Customers who have at least one delayed shipment.
------------------------------------------------------------

PRINT 'SUBQUERY: EXISTS';

SELECT
    CU.CustomerID,
    CU.CustomerName
FROM Customers CU
WHERE EXISTS (
    SELECT 1
    FROM Shipments S
    WHERE S.CustomerID = CU.CustomerID
      AND S.ShipmentStatus = 'Delayed'
);
GO

------------------------------------------------------------
-- SUBQUERY 4: CARRIERS WITH AVERAGE DELAY
-- ABOVE THE OVERALL AVERAGE DELAY
------------------------------------------------------------

PRINT 'SUBQUERY: CARRIER AVERAGE DELAY ABOVE OVERALL AVERAGE';

SELECT
    C.CarrierName,
    AVG(
        CAST(
            DATEDIFF(
                DAY,
                S.ExpectedDeliveryDate,
                S.ActualDeliveryDate
            ) AS DECIMAL(10,2)
        )
    ) AS AverageDelayDays
FROM Carriers C
INNER JOIN Shipments S
    ON C.CarrierID = S.CarrierID
WHERE S.ActualDeliveryDate IS NOT NULL
GROUP BY C.CarrierID, C.CarrierName
HAVING AVG(
    CAST(
        DATEDIFF(
            DAY,
            S.ExpectedDeliveryDate,
            S.ActualDeliveryDate
        ) AS DECIMAL(10,2)
    )
) > (
    SELECT AVG(
        CAST(
            DATEDIFF(
                DAY,
                ExpectedDeliveryDate,
                ActualDeliveryDate
            ) AS DECIMAL(10,2)
        )
    )
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
);
GO

------------------------------------------------------------
-- SUBQUERY 5: ANY
-- Carriers whose average delay exceeds at least one
-- individual carrier shipment delay.
------------------------------------------------------------

PRINT 'SUBQUERY: ANY';

SELECT
    C.CarrierName,
    AVG(
        CAST(
            DATEDIFF(
                DAY,
                S.ExpectedDeliveryDate,
                S.ActualDeliveryDate
            ) AS DECIMAL(10,2)
        )
    ) AS AverageDelayDays
FROM Carriers C
INNER JOIN Shipments S
    ON C.CarrierID = S.CarrierID
WHERE S.ActualDeliveryDate IS NOT NULL
GROUP BY C.CarrierID, C.CarrierName
HAVING AVG(
    CAST(
        DATEDIFF(
            DAY,
            S.ExpectedDeliveryDate,
            S.ActualDeliveryDate
        ) AS DECIMAL(10,2)
    )
) > ANY (
    SELECT CAST(
        DATEDIFF(
            DAY,
            ExpectedDeliveryDate,
            ActualDeliveryDate
        ) AS DECIMAL(10,2)
    )
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
);
GO

------------------------------------------------------------
-- SUBQUERY 6: ALL
-- Carriers whose average delay is greater than
-- every individual shipment delay.
------------------------------------------------------------

PRINT 'SUBQUERY: ALL';

SELECT
    C.CarrierName,
    AVG(
        CAST(
            DATEDIFF(
                DAY,
                S.ExpectedDeliveryDate,
                S.ActualDeliveryDate
            ) AS DECIMAL(10,2)
        )
    ) AS AverageDelayDays
FROM Carriers C
INNER JOIN Shipments S
    ON C.CarrierID = S.CarrierID
WHERE S.ActualDeliveryDate IS NOT NULL
GROUP BY C.CarrierID, C.CarrierName
HAVING AVG(
    CAST(
        DATEDIFF(
            DAY,
            S.ExpectedDeliveryDate,
            S.ActualDeliveryDate
        ) AS DECIMAL(10,2)
    )
) > ALL (
    SELECT CAST(
        DATEDIFF(
            DAY,
            ExpectedDeliveryDate,
            ActualDeliveryDate
        ) AS DECIMAL(10,2)
    )
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
);
GO

------------------------------------------------------------
-- SUBQUERY 7: CORRELATED SUBQUERY
-- Shipments whose cost is above the average cost
-- of shipments handled by the same carrier.
------------------------------------------------------------

PRINT 'SUBQUERY: SHIPPING COST ABOVE CARRIER AVERAGE';

SELECT
    S.ShipmentID,
    S.TrackingNumber,
    C.CarrierName,
    S.ShippingCost
FROM Shipments S
INNER JOIN Carriers C
    ON S.CarrierID = C.CarrierID
WHERE S.ShippingCost > (
    SELECT AVG(S2.ShippingCost)
    FROM Shipments S2
    WHERE S2.CarrierID = S.CarrierID
);
GO

------------------------------------------------------------
-- SUBQUERY 8: NESTED SUBQUERY
-- SECOND-HIGHEST DISTINCT SHIPPING COST PER HUB
------------------------------------------------------------

PRINT 'SUBQUERY: SECOND-HIGHEST SHIPPING COST PER HUB';

SELECT
    H.HubName,
    (
        SELECT MAX(S1.ShippingCost)
        FROM Shipments S1
        WHERE S1.OriginHubID = H.HubID
          AND S1.ShippingCost < (
              SELECT MAX(S2.ShippingCost)
              FROM Shipments S2
              WHERE S2.OriginHubID = H.HubID
          )
    ) AS SecondHighestShippingCost
FROM Hubs H
ORDER BY H.HubID;
GO

------------------------------------------------------------
-- REWRITE 1: SUBQUERY USING IN
------------------------------------------------------------

PRINT 'REWRITE 1: CUSTOMERS WITH SHIPMENTS TO MUMBAI - SUBQUERY';

SELECT CustomerID, CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Shipments
    WHERE DestinationHubID = 4
);
GO

PRINT 'REWRITE 1: CUSTOMERS WITH SHIPMENTS TO MUMBAI - JOIN';

SELECT DISTINCT
    CU.CustomerID,
    CU.CustomerName
FROM Customers CU
INNER JOIN Shipments S
    ON CU.CustomerID = S.CustomerID
WHERE S.DestinationHubID = 4;
GO

------------------------------------------------------------
-- REWRITE 2: CORRELATED SUBQUERY
-- SHIPMENTS ABOVE THEIR CARRIER'S AVERAGE COST
------------------------------------------------------------

PRINT 'REWRITE 2: CORRELATED SUBQUERY';

SELECT
    S.ShipmentID,
    S.TrackingNumber,
    S.CarrierID,
    S.ShippingCost
FROM Shipments S
WHERE S.ShippingCost > (
    SELECT AVG(S2.ShippingCost)
    FROM Shipments S2
    WHERE S2.CarrierID = S.CarrierID
);
GO

PRINT 'REWRITE 2: JOIN WITH AGGREGATED SUBQUERY';

SELECT
    S.ShipmentID,
    S.TrackingNumber,
    S.CarrierID,
    S.ShippingCost
FROM Shipments S
INNER JOIN (
    SELECT
        CarrierID,
        AVG(ShippingCost) AS AverageCarrierCost
    FROM Shipments
    GROUP BY CarrierID
) A
    ON S.CarrierID = A.CarrierID
WHERE S.ShippingCost > A.AverageCarrierCost;
GO

------------------------------------------------------------
-- COMPLETION
------------------------------------------------------------

PRINT 'DAY 7 SET 1 SQL REPORTS COMPLETED.';
GO
