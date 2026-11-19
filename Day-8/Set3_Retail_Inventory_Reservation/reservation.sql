
-- Create database tables

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    CategoryID INT,
    StockQuantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE
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

-- Insert sample products

INSERT INTO Products VALUES
(1, 'Laptop', 1, 20, 55000),
(2, 'Keyboard', 1, 50, 1200),
(3, 'Mouse', 1, 30, 700),
(4, 'Chair', 2, 10, 4500),
(5, 'Table', 2, 25, 8000);

-- Transaction: reserve inventory and place order

DECLARE @OrderID INT = 101;
DECLARE @ProductID INT = 1;
DECLARE @Quantity INT = 5;
DECLARE @Price DECIMAL(10,2) = 55000;

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Products
    SET StockQuantity = StockQuantity - @Quantity
    WHERE ProductID = @ProductID
      AND StockQuantity >= @Quantity;

    IF @@ROWCOUNT = 0
        THROW 50001, 'Insufficient stock or product not found.', 1;

    INSERT INTO Orders (OrderID, CustomerName, OrderDate)
    VALUES (@OrderID, 'Customer A', GETDATE());

    INSERT INTO OrderItems
        (OrderItemID, OrderID, ProductID, Quantity, UnitPrice)
    VALUES
        (1, @OrderID, @ProductID, @Quantity, @Price);

    COMMIT TRANSACTION;

    PRINT 'Order placed successfully.';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT ERROR_MESSAGE();

END CATCH;

-- Check updated inventory and order

SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderItems;

-- Correlated subquery:
-- Products with stock below their category average

SELECT
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    p.StockQuantity
FROM Products p
WHERE p.StockQuantity < (
    SELECT AVG(CAST(p2.StockQuantity AS DECIMAL(10,2)))
    FROM Products p2
    WHERE p2.CategoryID = p.CategoryID
);
