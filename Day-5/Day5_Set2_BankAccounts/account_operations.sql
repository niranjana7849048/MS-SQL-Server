
USE BankBranchAccounts;
GO

-- 1. INSERT a new account
DECLARE @NewAccountID INT;

INSERT INTO Accounts
(AccountNumber, AccountType, BranchID, ManagerID, Balance, OpenedDate)
VALUES
('ACC1011', 'Savings', 1, 1, 10000, '2026-09-20');

SET @NewAccountID = SCOPE_IDENTITY();

INSERT INTO AccountHolders (CustomerID, AccountID, OwnershipRole)
VALUES (1, @NewAccountID, 'Primary');

-- Verify inserted account
SELECT * FROM Accounts
WHERE AccountID = @NewAccountID;
GO

-- 2. UPDATE account balance
UPDATE Accounts
SET Balance = 15000
WHERE AccountNumber = 'ACC1011';

-- Verify updated account
SELECT * FROM Accounts
WHERE AccountNumber = 'ACC1011';
GO

-- 3. DELETE the test account
DELETE FROM Accounts
WHERE AccountNumber = 'ACC1011';

-- Verify deleted account
SELECT * FROM Accounts
WHERE AccountNumber = 'ACC1011';
GO

-- 4. WHERE with AND, OR, IN and BETWEEN
-- Last quarter: July to September 2026
-- Balance threshold: Above 20000

SELECT
    A.AccountNumber,
    C.CustomerName,
    A.AccountType,
    B.BranchName,
    A.Balance,
    A.OpenedDate
FROM Accounts A
JOIN AccountHolders AH ON A.AccountID = AH.AccountID
JOIN Customers C ON AH.CustomerID = C.CustomerID
JOIN Branches B ON A.BranchID = B.BranchID
WHERE
    A.OpenedDate BETWEEN '2026-07-01' AND '2026-09-30'
    AND A.Balance > 20000
    AND (
        A.AccountType IN ('Savings', 'Current')
        OR A.Balance BETWEEN 90000 AND 120000
    );
GO
