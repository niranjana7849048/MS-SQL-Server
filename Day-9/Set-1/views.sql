USE RetailOrderDB;
GO

-- 1. View: Order Summary
-- Hides cost price and supplier details

CREATE OR ALTER VIEW vw_order_summary
AS
SELECT
    o.OrderID,
    c.CustomerName,
    o.OrderDate,
    o.OrderStatus,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice,
    (oi.Quantity * oi.UnitPrice) AS ItemTotal
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID
INNER JOIN OrderItems oi
    ON o.OrderID = oi.OrderID
INNER JOIN Products p
    ON oi.ProductID = p.ProductID;
GO

-- Display order summary
SELECT * FROM vw_order_summary;
GO


-- 2. View: Low Stock Products

CREATE OR ALTER VIEW vw_low_stock
AS
SELECT
    ProductID,
    ProductName,
    StockQuantity,
    ReorderLevel
FROM Products
WHERE StockQuantity < ReorderLevel;
GO

-- Display low stock products
SELECT * FROM vw_low_stock;
GO


-- 3. Updatable View with WITH CHECK OPTION

CREATE OR ALTER VIEW vw_available_products
AS
SELECT
    ProductID,
    ProductName,
    SellingPrice,
    StockQuantity,
    ReorderLevel
FROM Products
WHERE StockQuantity > 0
WITH CHECK OPTION;
GO

-- View current available products
SELECT * FROM vw_available_products;
GO

-- Demonstrate an update through the view
UPDATE vw_available_products
SET SellingPrice = 46000
WHERE ProductID = 1;
GO

-- Verify the update
SELECT * FROM vw_available_products
WHERE ProductID = 1;
GO
