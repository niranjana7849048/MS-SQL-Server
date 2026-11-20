USE InsuranceDB;
GO

-- TASK 4: Cursor-based policy lapse processing

CREATE OR ALTER PROCEDURE usp_ProcessLapsedPolicies_Cursor
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PolicyID INT;
    DECLARE @OldStatus VARCHAR(20);

    DECLARE policy_cursor CURSOR LOCAL FAST_FORWARD
    FOR
        SELECT PolicyID, PolicyStatus
        FROM Policies
        WHERE RenewalDate < CAST(GETDATE() AS DATE)
          AND PolicyStatus = 'Active';

    OPEN policy_cursor;

    FETCH NEXT FROM policy_cursor
    INTO @PolicyID, @OldStatus;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Policies
        SET PolicyStatus = 'Lapsed'
        WHERE PolicyID = @PolicyID;

        INSERT INTO PolicyLapseLog
        (
            PolicyID,
            PreviousStatus,
            NewStatus,
            Remarks
        )
        VALUES
        (
            @PolicyID,
            @OldStatus,
            'Lapsed',
            'Policy premium renewal date has passed'
        );

        FETCH NEXT FROM policy_cursor
        INTO @PolicyID, @OldStatus;
    END;

    CLOSE policy_cursor;
    DEALLOCATE policy_cursor;
END;
GO

-- Execute cursor procedure

EXEC usp_ProcessLapsedPolicies_Cursor;
GO

SELECT * FROM Policies;
SELECT * FROM PolicyLapseLog;
GO

-- SET-BASED APPROACH

BEGIN TRANSACTION;

-- Log all policies before updating

INSERT INTO PolicyLapseLog
(
    PolicyID,
    PreviousStatus,
    NewStatus,
    Remarks
)
SELECT
    PolicyID,
    PolicyStatus,
    'Lapsed',
    'Policy premium renewal date has passed'
FROM Policies
WHERE RenewalDate < CAST(GETDATE() AS DATE)
  AND PolicyStatus = 'Active';

-- Update all eligible policies together

UPDATE Policies
SET PolicyStatus = 'Lapsed'
WHERE RenewalDate < CAST(GETDATE() AS DATE)
  AND PolicyStatus = 'Active';

COMMIT TRANSACTION;
GO

-- Verify results

SELECT * FROM Policies;
SELECT * FROM PolicyLapseLog;
GO