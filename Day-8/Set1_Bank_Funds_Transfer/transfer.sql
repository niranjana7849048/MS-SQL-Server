
IF OBJECT_ID('BankAccounts', 'U') IS NOT NULL
    DROP TABLE BankAccounts;

CREATE TABLE BankAccounts (
    AccountID INT PRIMARY KEY,
    AccountHolder VARCHAR(100),
    Balance DECIMAL(12,2),
    AccountStatus VARCHAR(20)
);

INSERT INTO BankAccounts VALUES
(101, 'Arun', 50000, 'ACTIVE'),
(102, 'Priya', 25000, 'ACTIVE'),
(103, 'Kumar', 10000, 'BLOCKED');

SELECT * FROM BankAccounts;

DECLARE @FromAccount INT = 101;
DECLARE @ToAccount INT = 102;
DECLARE @Amount DECIMAL(12,2) = 5000;

BEGIN TRY
    BEGIN TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM BankAccounts
        WHERE AccountID = @FromAccount
          AND AccountStatus = 'ACTIVE'
    )
        THROW 50001, 'Source account is invalid or inactive.', 1;

    IF NOT EXISTS (
        SELECT 1 FROM BankAccounts
        WHERE AccountID = @ToAccount
          AND AccountStatus = 'ACTIVE'
    )
        THROW 50002, 'Destination account is invalid or inactive.', 1;

    IF @Amount <= 0
        THROW 50003, 'Transfer amount must be positive.', 1;

    IF (
        SELECT Balance FROM BankAccounts
        WHERE AccountID = @FromAccount
    ) < @Amount
        THROW 50004, 'Insufficient account balance.', 1;

    UPDATE BankAccounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @FromAccount;

    UPDATE BankAccounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @ToAccount;

    COMMIT TRANSACTION;

    PRINT 'Funds transfer completed successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Transfer failed: ' + ERROR_MESSAGE();
    THROW;
END CATCH;

SELECT * FROM BankAccounts;

PRINT 'DELIBERATE FAILURE TEST';

SET @Amount = 3000;

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE BankAccounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @FromAccount
      AND AccountStatus = 'ACTIVE'
      AND Balance >= @Amount;

    IF @@ROWCOUNT = 0
        THROW 50005, 'Debit failed.', 1;

    THROW 50006, 'Simulated failure after debit.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Rollback executed: ' + ERROR_MESSAGE();
END CATCH;

SELECT * FROM BankAccounts;

PRINT 'SAVEPOINT TEST';

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE BankAccounts
    SET Balance = Balance - 2000
    WHERE AccountID = 101
      AND AccountStatus = 'ACTIVE'
      AND Balance >= 2000;

    IF @@ROWCOUNT = 0
        THROW 50007, 'Transfer debit failed.', 1;

    UPDATE BankAccounts
    SET Balance = Balance + 2000
    WHERE AccountID = 102
      AND AccountStatus = 'ACTIVE';

    IF @@ROWCOUNT = 0
        THROW 50008, 'Transfer credit failed.', 1;

    SAVE TRANSACTION TransferCompleted;

    BEGIN TRY
        UPDATE BankAccounts
        SET Balance = Balance - 100
        WHERE AccountID = 101;

        THROW 50009, 'Simulated fee posting failure.', 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION TransferCompleted;
        PRINT 'Fee posting rolled back. Transfer retained.';
        PRINT ERROR_MESSAGE();
    END CATCH;

    COMMIT TRANSACTION;
    PRINT 'Transfer committed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT 'Transaction failed: ' + ERROR_MESSAGE();
    THROW;
END CATCH;

SELECT * FROM BankAccounts;
