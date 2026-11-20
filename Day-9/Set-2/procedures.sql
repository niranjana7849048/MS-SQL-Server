USE InsuranceDB;
GO

-- TASK 2: Stored Procedure to Renew Policy

CREATE OR ALTER PROCEDURE usp_RenewPolicy
    @PolicyID INT,
    @NewRenewalDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldPremium DECIMAL(10,2);
    DECLARE @NewPremium DECIMAL(10,2);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate policy
        SELECT @OldPremium = PremiumAmount
        FROM Policies
        WHERE PolicyID = @PolicyID
          AND PolicyStatus = 'Active';

        IF @OldPremium IS NULL
            THROW 50001, 'Policy does not exist or is not active.', 1;

        -- Check for pending claims
        IF EXISTS (
            SELECT 1
            FROM Claims
            WHERE PolicyID = @PolicyID
              AND ClaimStatus = 'Pending'
        )
            THROW 50002, 'Policy has pending claims and cannot be renewed.', 1;

        -- Calculate new premium with 5% increase
        SET @NewPremium = @OldPremium * 1.05;

        -- Update policy
        UPDATE Policies
        SET PremiumAmount = @NewPremium,
            RenewalDate = @NewRenewalDate
        WHERE PolicyID = @PolicyID;

        -- Insert audit record
        INSERT INTO RenewalAudit
        (
            PolicyID,
            OldPremium,
            NewPremium,
            RenewalDate,
            Remarks
        )
        VALUES
        (
            @PolicyID,
            @OldPremium,
            @NewPremium,
            @NewRenewalDate,
            'Policy renewed successfully'
        );

        COMMIT TRANSACTION;

        SELECT
            @PolicyID AS PolicyID,
            @OldPremium AS OldPremium,
            @NewPremium AS NewPremium,
            @NewRenewalDate AS RenewalDate;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

-- Test renewal procedure
-- Policy 1 has no pending claim

EXEC usp_RenewPolicy
    @PolicyID = 1,
    @NewRenewalDate = '2027-11-20';
GO

-- TASK 3: Scalar Function
-- Apply 10% discount when there are no claims

CREATE OR ALTER FUNCTION fn_PremiumWithNoClaimDiscount
(
    @PolicyID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Premium DECIMAL(10,2);

    SELECT @Premium = PremiumAmount
    FROM Policies
    WHERE PolicyID = @PolicyID;

    IF @Premium IS NULL
        RETURN NULL;

    IF NOT EXISTS (
        SELECT 1
        FROM Claims
        WHERE PolicyID = @PolicyID
    )
        SET @Premium = @Premium * 0.90;

    RETURN @Premium;
END;
GO

-- Test scalar function

SELECT
    PolicyID,
    PremiumAmount,
    dbo.fn_PremiumWithNoClaimDiscount(PolicyID)
        AS DiscountedPremium
FROM Policies;
GO

-- Inline Table-Valued Function
-- Returns renewal quotes for an agent

CREATE OR ALTER FUNCTION fn_AgentRenewalQuotes
(
    @AgentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.PolicyID,
        c.CustomerName,
        p.PolicyType,
        p.PremiumAmount,
        p.RenewalDate,
        dbo.fn_PremiumWithNoClaimDiscount(p.PolicyID)
            AS RenewalQuote
    FROM Policies p
    INNER JOIN Customers c
        ON p.CustomerID = c.CustomerID
    WHERE p.AgentID = @AgentID
      AND p.PolicyStatus = 'Active'
);
GO

-- Test table-valued function

SELECT *
FROM dbo.fn_AgentRenewalQuotes(1);
GO