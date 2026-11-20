USE TelecomDB;
GO

-- TASK 2: Recharge stored procedure

CREATE OR ALTER PROCEDURE usp_Recharge
    @SubscriberID INT,
    @PlanID INT,
    @RechargeAmount DECIMAL(10,2),
    @NewBalance DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PlanAmount DECIMAL(10,2);
    DECLARE @ValidityDays INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate recharge amount
        IF @RechargeAmount <= 0
            THROW 50001, 'Recharge amount must be greater than zero.', 1;

        -- Validate subscriber
        IF NOT EXISTS (
            SELECT 1
            FROM Subscribers
            WHERE SubscriberID = @SubscriberID
              AND SubscriberType = 'Prepaid'
        )
            THROW 50002, 'Invalid or non-prepaid subscriber.', 1;

        -- Validate plan
        SELECT
            @PlanAmount = RechargeAmount,
            @ValidityDays = ValidityDays
        FROM RechargePlans
        WHERE PlanID = @PlanID;

        IF @PlanAmount IS NULL
            THROW 50003, 'Invalid recharge plan.', 1;

        IF @RechargeAmount <> @PlanAmount
            THROW 50004, 'Recharge amount does not match the selected plan.', 1;

        -- Update balance and validity
        UPDATE Subscribers
        SET Balance = Balance + @RechargeAmount,
            ValidityEndDate = DATEADD(
                DAY,
                @ValidityDays,
                CASE
                    WHEN ValidityEndDate > CAST(GETDATE() AS DATE)
                    THEN ValidityEndDate
                    ELSE CAST(GETDATE() AS DATE)
                END
            )
        WHERE SubscriberID = @SubscriberID;

        -- Insert recharge history
        INSERT INTO RechargeHistory
        (
            SubscriberID,
            PlanID,
            RechargeAmount
        )
        VALUES
        (
            @SubscriberID,
            @PlanID,
            @RechargeAmount
        );

        -- Return updated balance
        SELECT @NewBalance = Balance
        FROM Subscribers
        WHERE SubscriberID = @SubscriberID;

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SET @NewBalance = NULL;
        THROW;
    END CATCH
END;
GO

-- Test recharge procedure

DECLARE @Balance DECIMAL(10,2);

EXEC usp_Recharge
    @SubscriberID = 1,
    @PlanID = 1,
    @RechargeAmount = 50,
    @NewBalance = @Balance OUTPUT;

SELECT @Balance AS UpdatedBalance;
GO


-- TASK 3: Scalar function
-- Calculate validity days remaining

CREATE OR ALTER FUNCTION fn_ValidityDaysLeft
(
    @SubscriberID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Days INT;

    SELECT @Days = DATEDIFF(
        DAY,
        CAST(GETDATE() AS DATE),
        ValidityEndDate
    )
    FROM Subscribers
    WHERE SubscriberID = @SubscriberID;

    RETURN @Days;
END;
GO

-- Test scalar function

SELECT
    SubscriberID,
    SubscriberName,
    dbo.fn_ValidityDaysLeft(SubscriberID) AS ValidityDaysLeft
FROM Subscribers
WHERE SubscriberType = 'Prepaid';
GO


-- Inline table-valued function
-- Return the last five recharges of a subscriber

CREATE OR ALTER FUNCTION fn_LastFiveRecharges
(
    @SubscriberID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (5)
        RechargeID,
        SubscriberID,
        PlanID,
        RechargeAmount,
        RechargeDate
    FROM RechargeHistory
    WHERE SubscriberID = @SubscriberID
    ORDER BY RechargeDate DESC, RechargeID DESC
);
GO

-- Test table-valued function

SELECT *
FROM dbo.fn_LastFiveRecharges(1);
GO