USE TelecomDB;
GO

-- TASK 4: Cursor-based low-balance notifications

CREATE OR ALTER PROCEDURE usp_LowBalanceNotifications_Cursor
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SubscriberID INT;

    DECLARE subscriber_cursor CURSOR LOCAL FAST_FORWARD
    FOR
        SELECT SubscriberID
        FROM Subscribers
        WHERE SubscriberType = 'Prepaid'
          AND Balance < 50;

    OPEN subscriber_cursor;

    FETCH NEXT FROM subscriber_cursor INTO @SubscriberID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO NotificationLog
        (SubscriberID, Message, IsRead)
        VALUES
        (
            @SubscriberID,
            'Your prepaid balance is below 50. Please recharge.',
            0
        );

        FETCH NEXT FROM subscriber_cursor INTO @SubscriberID;
    END;

    CLOSE subscriber_cursor;
    DEALLOCATE subscriber_cursor;
END;
GO

-- Execute cursor procedure

EXEC usp_LowBalanceNotifications_Cursor;
GO

SELECT * FROM NotificationLog;
GO


-- SET-BASED APPROACH

INSERT INTO NotificationLog
(SubscriberID, Message, IsRead)
SELECT
    SubscriberID,
    'Your prepaid balance is below 50. Please recharge.',
    0
FROM Subscribers
WHERE SubscriberType = 'Prepaid'
  AND Balance < 50;
GO

-- Display notification records

SELECT * FROM NotificationLog;
GO


-- Compare execution time

SET STATISTICS TIME ON;

-- Cursor execution can be measured by executing:
-- EXEC usp_LowBalanceNotifications_Cursor;

-- Set-based execution can be measured by executing:
-- INSERT INTO NotificationLog (SubscriberID, Message, IsRead)
-- SELECT SubscriberID,
--        'Your prepaid balance is below 50. Please recharge.',
--        0
-- FROM Subscribers
-- WHERE SubscriberType = 'Prepaid'
--   AND Balance < 50;

SET STATISTICS TIME OFF;
GO