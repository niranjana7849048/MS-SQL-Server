-- Day 10 - Set 2: Bank Account Balance Guard
-- Test Evidence

USE BankBalanceGuardDB;
GO

-- TEST 1: View initial accounts
SELECT * FROM dbo.accounts;
GO

-- TEST 2: Insert a transaction
INSERT INTO dbo.account_transaction
    (transaction_id, account_id, transaction_type, amount)
VALUES
    (104, 1, 'Deposit', 1000);
GO

SELECT * FROM dbo.transaction_audit;
GO

-- TEST 3: Update a transaction
UPDATE dbo.account_transaction
SET amount = 1500
WHERE transaction_id = 104;
GO

SELECT * FROM dbo.transaction_audit;
GO

-- TEST 4: Delete a transaction
DELETE FROM dbo.account_transaction
WHERE transaction_id = 104;
GO

SELECT * FROM dbo.transaction_audit;
GO

-- TEST 5: Valid update using the view
UPDATE dbo.vw_accounts
SET balance = balance + 1000
WHERE account_id = 1;
GO

SELECT * FROM dbo.accounts;
GO

-- TEST 6: Batch update of five accounts
-- Account 3 will have a negative savings balance.
-- The entire statement should be rejected.

BEGIN TRY
    UPDATE dbo.vw_accounts
    SET balance =
        CASE
            WHEN account_id = 1 THEN balance + 500
            WHEN account_id = 2 THEN balance + 1000
            WHEN account_id = 3 THEN -500
            WHEN account_id = 4 THEN balance + 2000
            WHEN account_id = 5 THEN balance + 300
        END
    WHERE account_id IN (1, 2, 3, 4, 5);

    PRINT 'Batch update completed successfully.';
END TRY
BEGIN CATCH
    PRINT 'Batch update rejected.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- Verify that none of the five updates were applied.
SELECT * FROM dbo.accounts
ORDER BY account_id;
GO

-- TEST 7: Verify transaction audit records
SELECT * FROM dbo.transaction_audit
ORDER BY audit_id;
GO