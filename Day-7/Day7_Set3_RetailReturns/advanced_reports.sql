
CREATE DATABASE RetailReturnsReporting;
GO

USE RetailReturnsReporting;
GO

-- =========================================
-- 1. CREATE TABLES
-- =========================================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    OrderItemID INT,
    ReturnDate DATE,
    ReturnQuantity INT,
    ReturnReason VARCHAR(100),
    ProcessedBy INT,
    FOREIGN KEY (OrderItemID) REFERENCES OrderItems(OrderItemID),
    FOREIGN KEY (ProcessedBy) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Refunds (
    RefundID INT PRIMARY KEY,
    ReturnID INT,
    RefundAmount DECIMAL(10,2),
    RefundDate DATE,
    RefundStatus VARCHAR(30),
    FOREIGN KEY (ReturnID) REFERENCES Returns(ReturnID)
);

-- =========================================
-- 2. INSERT SAMPLE DATA
-- =========================================

INSERT INTO Customers VALUES
(1, 'Arun Kumar', 'Chennai'),
(2, 'Priya Sharma', 'Bangalore'),
(3, 'Rahul Das', 'Mumbai'),
(4, 'Divya Nair', 'Hyderabad'),
(5, 'Karthik Raj', 'Chennai'),
(6, 'Meena Iyer', 'Coimbatore');

INSERT INTO Employees VALUES
(101, 'Ramesh', NULL),
(102, 'Suresh', 101),
(103, 'Anitha', 101),
(104, 'Kavitha', 102),
(105, 'Vijay', 102);

INSERT INTO Products VALUES
(201, 'Laptop', 'Electronics', 60000),
(202, 'Smartphone', 'Electronics', 30000),
(203, 'Headphones', 'Accessories', 2500),
(204, 'Office Chair', 'Furniture', 8000),
(205, 'Keyboard', 'Accessories', 1500),
(206, 'Monitor', 'Electronics', 12000),
(207, 'Desk', 'Furniture', 15000);

INSERT INTO Orders VALUES
(1001, 1, '2026-01-05'),
(1002, 2, '2026-01-08'),
(1003, 3, '2026-01-12'),
(1004, 1, '2026-02-02'),
(1005, 4, '2026-02-10'),
(1006, 5, '2026-02-15'),
(1007, 2, '2026-03-01'),
(1008, 6, '2026-03-05'),
(1009, 3, '2026-03-12'),
(1010, 4, '2026-03-18');

INSERT INTO OrderItems VALUES
(1, 1001, 201, 1, 60000),
(2, 1001, 203, 2, 2500),
(3, 1002, 202, 1, 30000),
(4, 1002, 205, 1, 1500),
(5, 1003, 204, 1, 8000),
(6, 1004, 206, 1, 12000),
(7, 1004, 203, 1, 2500),
(8, 1005, 201, 1, 60000),
(9, 1006, 205, 2, 1500),
(10, 1007, 202, 1, 30000),
(11, 1007, 204, 1, 8000),
(12, 1008, 207, 1, 15000),
(13, 1009, 203, 2, 2500),
(14, 1010, 206, 1, 12000),
(15, 1010, 205, 1, 1500);

INSERT INTO Returns VALUES
(501, 1, '2026-01-10', 1, 'Damaged product', 102),
(502, 2, '2026-01-11', 1, 'Wrong item', 103),
(503, 3, '2026-01-15', 1, 'Defective product', 104),
(504, 5, '2026-01-20', 1, 'Changed mind', 102),
(505, 6, '2026-02-08', 1, 'Damaged product', 105),
(506, 8, '2026-02-18', 1, 'Defective product', 103),
(507, 10, '2026-03-05', 1, 'Wrong item', 104),
(508, 13, '2026-03-16', 1, 'Damaged product', 105),
(509, 15, '2026-03-20', 1, 'Changed mind', 102);

INSERT INTO Refunds VALUES
(701, 501, 60000, '2026-01-12', 'Completed'),
(702, 502, 2500, '2026-01-13', 'Completed'),
(703, 503, 30000, '2026-01-18', 'Completed'),
(704, 504, 8000, '2026-01-22', 'Pending'),
(705, 505, 12000, '2026-02-10', 'Completed'),
(706, 506, 60000, '2026-02-20', 'Completed'),
(707, 507, 30000, '2026-03-08', 'Pending'),
(708, 508, 5000, '2026-03-18', 'Completed');

-- =========================================
-- REPORT 1: Return details using EQUI JOINS
-- =========================================

SELECT
    r.ReturnID,
    c.CustomerName,
    o.OrderID,
    p.ProductName,
    r.ReturnQuantity,
    r.ReturnReason,
    r.ReturnDate,
    e.EmployeeName AS ProcessedBy
FROM Returns r
INNER JOIN OrderItems oi
    ON r.OrderItemID = oi.OrderItemID
INNER JOIN Orders o
    ON oi.OrderID = o.OrderID
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
INNER JOIN Products p
    ON oi.ProductID = p.ProductID
INNER JOIN Employees e
    ON r.ProcessedBy = e.EmployeeID
ORDER BY r.ReturnID;

-- =========================================
-- REPORT 2: Employees and their managers
-- SELF JOIN
-- =========================================

SELECT
    e.EmployeeName AS Employee,
    m.EmployeeName AS Manager
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID
ORDER BY e.EmployeeID;

-- =========================================
-- REPORT 3: Products that have never been returned
-- NOT IN SUBQUERY
-- =========================================

SELECT
    ProductID,
    ProductName,
    Category
FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT oi.ProductID
    FROM OrderItems oi
    INNER JOIN Returns r
        ON oi.OrderItemID = r.OrderItemID
);

-- =========================================
-- REPORT 4: Customers who have made returns
-- EXISTS SUBQUERY
-- =========================================

SELECT
    c.CustomerID,
    c.CustomerName,
    c.City
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

-- =========================================
-- REPORT 5: Customers who have never returned
-- NOT EXISTS SUBQUERY
-- =========================================

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

-- =========================================
-- REPORT 6: Products priced above ANY
-- returned product price
-- =========================================

SELECT
    ProductID,
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

-- =========================================
-- REPORT 7: Products priced above ALL
-- returned product prices
-- =========================================

SELECT
    ProductID,
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

-- =========================================
-- REPORT 8: Refund details using nested subquery
-- Refunds greater than the average refund
-- =========================================

SELECT
    RefundID,
    ReturnID,
    RefundAmount,
    RefundStatus
FROM Refunds
WHERE RefundAmount > (
    SELECT AVG(RefundAmount)
    FROM Refunds
)
ORDER BY RefundAmount DESC;

-- =========================================
-- REPORT 9: Total refund amount by customer
-- JOIN + GROUP BY
-- =========================================

SELECT
    c.CustomerID,
    c.CustomerName,
    SUM(rf.RefundAmount) AS TotalRefundAmount
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderItems oi
    ON o.OrderID = oi.OrderID
INNER JOIN Returns r
    ON oi.OrderItemID = r.OrderItemID
INNER JOIN Refunds rf
    ON r.ReturnID = rf.ReturnID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRefundAmount DESC;

-- =========================================
-- REPORT 10: Products returned more than
-- the average number of returns per product
-- CORRELATED + NESTED SUBQUERY
-- =========================================

SELECT
    p.ProductID,
    p.ProductName,
    COUNT(r.ReturnID) AS ReturnCount
FROM Products p
INNER JOIN OrderItems oi
    ON p.ProductID = oi.ProductID
INNER JOIN Returns r
    ON oi.OrderItemID = r.OrderItemID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(r.ReturnID) > (
    SELECT AVG(ReturnCount)
    FROM (
        SELECT COUNT(r2.ReturnID) AS ReturnCount
        FROM Products p2
        INNER JOIN OrderItems oi2
            ON p2.ProductID = oi2.ProductID
        LEFT JOIN Returns r2
            ON oi2.OrderItemID = r2.OrderItemID
        GROUP BY p2.ProductID
    ) AS ProductReturnCounts
);

-- =========================================
-- REPORT 11: Refund status summary
-- =========================================

SELECT
    RefundStatus,
    COUNT(*) AS NumberOfRefunds,
    SUM(RefundAmount) AS TotalRefundAmount
FROM Refunds
GROUP BY RefundStatus
ORDER BY TotalRefundAmount DESC;

-- =========================================
-- REPORT 12: Returns handled by employees
-- =========================================

SELECT
    e.EmployeeID,
    e.EmployeeName,
    COUNT(r.ReturnID) AS ReturnsHandled
FROM Employees e
LEFT JOIN Returns r
    ON e.EmployeeID = r.ProcessedBy
GROUP BY e.EmployeeID, e.EmployeeName
ORDER BY ReturnsHandled DESC;
