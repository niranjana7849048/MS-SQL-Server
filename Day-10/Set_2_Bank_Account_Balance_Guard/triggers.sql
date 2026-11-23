-- Day 10 - Set 2: Bank Account Balance Guard
-- SQL Server 2025

-- 1. Create database
IF DB_ID('BankBalanceGuardDB') IS NULL
    CREATE DATABASE BankBalanceGuardDB;
GO

USE BankBalanceGuardDB;
GO

-- 2. Create accounts table
IF OBJECT_ID('dbo.accounts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.accounts
    (
        account_id INT PRIMARY KEY,
        account_holder VARCHAR(100) NOT NULL,
        account_type VARCHAR(20) NOT NULL,
        balance DECIMAL(12,2) NOT NULL
    );
END;
GO

-- 3. Create account_transaction table
IF OBJECT_ID('dbo.account_transaction', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.account_transaction
    (
        transaction_id INT PRIMARY KEY,
        account_id INT NOT NULL,
        transaction_type VARCHAR(20) NOT NULL,
        amount DECIMAL(12,2) NOT NULL,
        transaction_date DATETIME2 DEFAULT SYSDATETIME()
    );
END;
GO

-- 4. Create transaction audit table
IF OBJECT_ID('dbo.transaction_audit', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.transaction_audit
    (
        audit_id INT IDENTITY(1,1) PRIMARY KEY,
        transaction_id INT,
        account_id INT,
        action_type VARCHAR(10),
        old_type VARCHAR(20),
        new_type VARCHAR(20),
        old_amount DECIMAL(12,2),
        new_amount DECIMAL(12,2),
        changed_by VARCHAR(128),
        changed_at DATETIME2 DEFAULT SYSDATETIME()
    );
END;
GO

-- 5. Insert sample accounts
IF NOT EXISTS (SELECT 1 FROM dbo.accounts)
BEGIN
    INSERT INTO dbo.accounts
        (account_id, account_holder, account_type, balance)
    VALUES
        (1, 'Arun', 'Savings', 10000),
        (2, 'Priya', 'Savings', 15000),
        (3, 'Karthik', 'Savings', 20000),
        (4, 'Divya', 'Current', 25000),
        (5, 'Meena', 'Savings', 12000);
END;
GO

-- 6. Insert sample transactions
IF NOT EXISTS (SELECT 1 FROM dbo.account_transaction)
BEGIN
    INSERT INTO dbo.account_transaction
        (transaction_id, account_id, transaction_type, amount)
    VALUES
        (101, 1, 'Deposit', 5000),
        (102, 2, 'Withdrawal', 2000),
        (103, 3, 'Deposit', 3000);
END;
GO

-- 7. AFTER INSERT, UPDATE, DELETE trigger
CREATE OR ALTER TRIGGER dbo.trg_transaction_audit
ON dbo.account_transaction
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.transaction_audit
    (
        transaction_id,
        account_id,
        action_type,
        old_type,
        new_type,
        old_amount,
        new_amount,
        changed_by,
        changed_at
    )
    SELECT
        COALESCE(i.transaction_id, d.transaction_id),
        COALESCE(i.account_id, d.account_id),
        CASE
            WHEN d.transaction_id IS NULL THEN 'INSERT'
            WHEN i.transaction_id IS NULL THEN 'DELETE'
            ELSE 'UPDATE'
        END,
        d.transaction_type,
        i.transaction_type,
        d.amount,
        i.amount,
        SUSER_SNAME(),
        SYSDATETIME()
    FROM inserted i
    FULL OUTER JOIN deleted d
        ON i.transaction_id = d.transaction_id;
END;
GO

-- 8. Create view for account balance updates
CREATE OR ALTER VIEW dbo.vw_accounts
AS
SELECT
    account_id,
    account_holder,
    account_type,
    balance
FROM dbo.accounts;
GO

-- 9. INSTEAD OF UPDATE trigger on the view
-- Prevents savings balances from becoming negative.
CREATE OR ALTER TRIGGER dbo.trg_guard_savings_balance
ON dbo.vw_accounts
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Reject the entire batch if any savings balance is negative.
    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        WHERE i.account_type = 'Savings'
          AND i.balance < 0
    )
    BEGIN
        THROW 50001,
              'Savings account balance cannot be negative.',
              1;
    END;

    -- Apply valid updates to the base table.
    UPDATE a
    SET
        a.account_holder = i.account_holder,
        a.account_type = i.account_type,
        a.balance = i.balance
    FROM dbo.accounts a
    INNER JOIN inserted i
        ON a.account_id = i.account_id;
END;
GO
