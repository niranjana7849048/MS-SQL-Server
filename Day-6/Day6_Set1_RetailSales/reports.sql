
CREATE DATABASE RetailSalesReporting;
GO

USE RetailSalesReporting;
GO

-- =========================================
-- 1. CREATE TABLES
-- =========================================

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    PaymentStatus VARCHAR(20) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Order_Items (
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- =========================================
-- 2. INSERT SAMPLE DATA
-- =========================================

INSERT INTO Customers VALUES
(1, 'Arun Kumar', 'Chennai', 'arun@gmail.com'),
(2, 'Priya Sharma', 'Bangalore', 'priya@gmail.com'),
(3, 'Rahul Verma', 'Chennai', 'rahul@gmail.com'),
(4, 'Sneha Raj', 'Mumbai', 'sneha@gmail.com'),
(5, 'Karthik S', 'Bangalore', 'karthik@gmail.com'),
(6, 'Divya Nair', 'Hyderabad', 'divya@gmail.com'),
(7, 'Vikram Rao', 'Mumbai', 'vikram@gmail.com');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Smartphone', 'Electronics', 25000),
(103, 'Headphones', 'Accessories', 2000),
(104, 'Keyboard', 'Accessories', 1500),
(105, 'Office Chair', 'Furniture', 8000),
(106, 'Desk', 'Furniture', 12000);

INSERT INTO Orders VALUES
(1001, 1, '2026-01-05', 'Paid'),
(1002, 1, '2026-01-15', 'Paid'),
(1003, 1, '2026-02-10', 'Pending'),
(1004, 1, '2026-03-12', 'Paid'),
(1005, 2, '2026-01-20', 'Paid'),
(1006, 2, '2026-02-18', 'Paid'),
(1007, 2, '2026-03-22', 'Pending'),
(1008, 3, '2026-02-05', 'Paid'),
(1009, 3, '2026-03-08', 'Paid'),
(1010, 4, '2026-01-25', 'Pending'),
(1011, 4, '2026-03-15', 'Paid'),
(1012, 5, '2026-02-28', 'Paid'),
(1013, 6, '2026-03-25', 'Paid');

INSERT INTO Order_Items VALUES
(1, 1001, 101, 1, 55000),
(2, 1001, 103, 2, 2000),
(3, 1002, 102, 1, 25000),
(4, 1003, 104, 2, 1500),
(5, 1004, 101, 1, 55000),
(6, 1004, 105, 1, 8000),
(7, 1005, 102, 2, 25000),
(8, 1006, 103, 3, 2000),
(9, 1007, 106, 1, 12000),
(10, 1008, 101, 1, 55000),
(11, 1008, 104, 1, 1500),
(12, 1009, 102, 1, 25000),
(13, 1010, 105, 2, 8000),
(14, 1011, 106, 1, 12000),
(15, 1012, 103, 2, 2000),
(16, 1013, 104, 3, 1500);
GO

-- =========================================
-- 3. QUERY 1: TOP 5 PRODUCTS BY REVENUE
-- =========================================

SELECT TOP 5
    P.ProductID,
    P.ProductName,
    SUM(OI.Quantity * OI.UnitPrice) AS TotalRevenue
FROM Products P
INNER JOIN Order_Items OI
    ON P.ProductID = OI.ProductID
GROUP BY P.ProductID, P.ProductName
ORDER BY TotalRevenue DESC;
GO

-- =========================================
-- 4. QUERY 2: MONTH-WISE SALES
-- =========================================

SELECT
    FORMAT(O.OrderDate, 'yyyy-MM') AS SalesMonth,
    ROUND(SUM(OI.Quantity * OI.UnitPrice), 2) AS MonthlyRevenue
FROM Orders O
INNER JOIN Order_Items OI
    ON O.OrderID = OI.OrderID
GROUP BY FORMAT(O.OrderDate, 'yyyy-MM')
ORDER BY SalesMonth;
GO

-- =========================================
-- 5. QUERY 3: CUSTOMERS WITH MORE THAN 3 ORDERS
-- =========================================

SELECT
    C.CustomerID,
    C.CustomerName,
    COUNT(O.OrderID) AS TotalOrders
FROM Customers C
INNER JOIN Orders O
    ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.CustomerName
HAVING COUNT(O.OrderID) > 3;
GO

-- =========================================
-- 6. QUERY 4: AVERAGE BASKET VALUE BY CITY
-- =========================================

SELECT
    C.City,
    ROUND(AVG(OrderTotals.OrderValue), 2) AS AverageBasketValue
FROM Customers C
INNER JOIN Orders O
    ON C.CustomerID = O.CustomerID
INNER JOIN (
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice) AS OrderValue
    FROM Order_Items
    GROUP BY OrderID
) OrderTotals
    ON O.OrderID = OrderTotals.OrderID
GROUP BY C.City;
GO

-- =========================================
-- 7. QUERY 5: ORDERS WITHOUT PAYMENT
-- =========================================

SELECT
    O.OrderID,
    C.CustomerName,
    O.PaymentStatus
FROM Orders O
LEFT JOIN Customers C
    ON O.CustomerID = C.CustomerID
WHERE O.PaymentStatus = 'Pending';
GO

-- =========================================
-- 8. QUERY 6: CUSTOMERS WITH NO ORDERS
-- =========================================

SELECT
    C.CustomerID,
    C.CustomerName,
    C.City
FROM Customers C
LEFT JOIN Orders O
    ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;
GO

-- =========================================
-- 9. QUERY 7: PRODUCT CATEGORY REVENUE SHARE
-- =========================================

SELECT
    P.Category,
    SUM(OI.Quantity * OI.UnitPrice) AS CategoryRevenue,
    ROUND(
        SUM(OI.Quantity * OI.UnitPrice) * 100.0 /
        SUM(SUM(OI.Quantity * OI.UnitPrice)) OVER (),
        2
    ) AS RevenueSharePercentage
FROM Products P
INNER JOIN Order_Items OI
    ON P.ProductID = OI.ProductID
GROUP BY P.Category;
GO

-- =========================================
-- 10. QUERY 8: DAY WITH HIGHEST SALES
-- =========================================

SELECT TOP 1
    O.OrderDate,
    SUM(OI.Quantity * OI.UnitPrice) AS DailyRevenue
FROM Orders O
INNER JOIN Order_Items OI
    ON O.OrderID = OI.OrderID
GROUP BY O.OrderDate
ORDER BY DailyRevenue DESC;
GO

-- =========================================
-- 11. CUSTOMER-FRIENDLY OUTPUT
-- STRING, DATE AND MATHEMATICAL FUNCTIONS
-- =========================================

SELECT
    UPPER(C.CustomerName) AS CustomerName,
    CONCAT(C.City, ', India') AS Location,
    O.OrderID,
    FORMAT(O.OrderDate, 'dd-MMM-yyyy') AS OrderDate,
    DATEDIFF(DAY, O.OrderDate, GETDATE()) AS DaysSinceOrder,
    ROUND(
        SUM(OI.Quantity * OI.UnitPrice), 2
    ) AS OrderAmount
FROM Customers C
INNER JOIN Orders O
    ON C.CustomerID = O.CustomerID
INNER JOIN Order_Items OI
    ON O.OrderID = OI.OrderID
GROUP BY
    C.CustomerName,
    C.City,
    O.OrderID,
    O.OrderDate;
GO

-- =========================================
-- 12. NULL BEHAVIOUR: COUNT AND AVG
-- =========================================

SELECT
    COUNT(*) AS TotalOrderRows,
    COUNT(Email) AS CustomersWithEmail,
    COUNT(*) - COUNT(Email) AS CustomersWithoutEmail
FROM Customers;
GO

SELECT
    AVG(Price) AS AverageProductPrice,
    AVG(NULLIF(Price, 0)) AS AverageIgnoringZeroPrices
FROM Products;
GO

-- =========================================
-- 13. VERIFY TABLE ROW COUNTS
-- =========================================

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Order_Items', COUNT(*) FROM Order_Items;
GO
