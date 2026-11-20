USE RetailOrderDB;
GO

-- TASK 2: Stored Procedure to Place an Order

CREATE OR ALTER PROCEDURE usp_PlaceOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT,
    @OrderID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate quantity
        IF @Quantity <= 0
            THROW 50001, 'Quantity must be greater than zero.', 1;

        -- Validate customer
        IF NOT EXISTS (
            SELECT 1 FROM Customers
            WHERE CustomerID = @CustomerID
        )
            THROW 50002, 'Invalid customer ID.', 1;

        -- Validate product and stock
        IF NOT EXISTS (
            SELECT 1
            FROM Products
            WHERE ProductID = @ProductID
              AND StockQuantity >= @Quantity
        )
            THROW 50003, 'Product unavailable or insufficient stock.', 1;

        -- Create order
        INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
        VALUES (@CustomerID, SYSDATETIME(), 'Pending');

        SET @OrderID = SCOPE_IDENTITY();

        -- Insert order item
        INSERT INTO OrderItems
            (OrderID, ProductID, Quantity, UnitPrice)
        SELECT
            @OrderID,
            ProductID,
            @Quantity,
            SellingPrice
        FROM Products
        WHERE ProductID = @ProductID;

        -- Reduce stock
        UPDATE Products
        SET StockQuantity = StockQuantity - @Quantity
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;

        PRINT 'Order placed successfully.';
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @OrderID = NULL;
        THROW;
    END CATCH
END;
GO


-- Test stored procedure

DECLARE @NewOrderID INT;

EXEC usp_PlaceOrder
    @CustomerID = 1,
    @ProductID = 1,
    @Quantity = 2,
    @OrderID = @NewOrderID OUTPUT;

SELECT @NewOrderID AS GeneratedOrderID;
GO


-- TASK 3: Scalar Function
-- Calculates order total including 18% tax

CREATE OR ALTER FUNCTION fn_OrderTotalWithTax
(
    @OrderID INT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @Total DECIMAL(12,2);

    SELECT @Total =
        SUM(Quantity * UnitPrice) * 1.18
    FROM OrderItems
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO

-- Test scalar function

SELECT
    OrderID,
    dbo.fn_OrderTotalWithTax(OrderID) AS TotalWithTax
FROM Orders;
GO


-- Inline Table-Valued Function
-- Returns all orders belonging to a customer

CREATE OR ALTER FUNCTION fn_CustomerOrders
(
    @CustomerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        o.OrderID,
        o.OrderDate,
        o.OrderStatus,
        SUM(oi.Quantity * oi.UnitPrice) AS OrderTotal
    FROM Orders o
    INNER JOIN OrderItems oi
        ON o.OrderID = oi.OrderID
    WHERE o.CustomerID = @CustomerID
    GROUP BY
        o.OrderID,
        o.OrderDate,
        o.OrderStatus
);
GO

-- Test table-valued function

SELECT *
FROM dbo.fn_CustomerOrders(1);
GO