USE RetailOrderDB;
GO

-- TASK 4: Cursor-based follow-up processing
-- Find pending orders older than 3 days.

CREATE OR ALTER PROCEDURE usp_FollowUpPendingOrders_Cursor
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderID INT;

    DECLARE order_cursor CURSOR LOCAL FAST_FORWARD
    FOR
        SELECT OrderID
        FROM Orders
        WHERE OrderStatus = 'Pending'
          AND OrderDate < DATEADD(DAY, -3, SYSDATETIME());

    OPEN order_cursor;

    FETCH NEXT FROM order_cursor INTO @OrderID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO OrderFollowUps (OrderID, Remarks)
        VALUES (@OrderID, 'Follow-up required: Order pending for more than 3 days.');

        FETCH NEXT FROM order_cursor INTO @OrderID;
    END;

    CLOSE order_cursor;
    DEALLOCATE order_cursor;
END;
GO


-- Execute cursor procedure

EXEC usp_FollowUpPendingOrders_Cursor;
GO

-- Display cursor-generated follow-ups

SELECT * FROM OrderFollowUps;
GO


-- SET-BASED APPROACH
-- Achieves the same task without a cursor.

INSERT INTO OrderFollowUps (OrderID, Remarks)
SELECT
    o.OrderID,
    'Follow-up required: Order pending for more than 3 days.'
FROM Orders o
WHERE o.OrderStatus = 'Pending'
  AND o.OrderDate < DATEADD(DAY, -3, SYSDATETIME())
  AND NOT EXISTS
  (
      SELECT 1
      FROM OrderFollowUps f
      WHERE f.OrderID = o.OrderID
  );
GO

-- Display final follow-up records

SELECT * FROM OrderFollowUps;
GO