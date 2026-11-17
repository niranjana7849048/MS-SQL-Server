
USE BankBranchAccounts;
GO

-- 1. Insert Branches
INSERT INTO Branches (BranchName, BranchAddress, City)
VALUES
('Chennai Main', 'Anna Salai', 'Chennai'),
('Tambaram Branch', 'GST Road', 'Chennai'),
('Bangalore Central', 'MG Road', 'Bangalore'),
('Mumbai Central', 'Fort Area', 'Mumbai'),
('Delhi Main', 'Connaught Place', 'Delhi'),
('Hyderabad Branch', 'Hitech City', 'Hyderabad'),
('Pune Branch', 'FC Road', 'Pune'),
('Kolkata Branch', 'Park Street', 'Kolkata'),
('Coimbatore Branch', 'RS Puram', 'Coimbatore'),
('Madurai Branch', 'KK Nagar', 'Madurai');
GO

-- 2. Insert Relationship Managers
INSERT INTO RelationshipManagers (ManagerName, Email, BranchID)
VALUES
('Arun Kumar', 'arun@bank.com', 1),
('Priya Sharma', 'priya@bank.com', 2),
('Rahul Verma', 'rahul@bank.com', 3),
('Sneha Patel', 'sneha@bank.com', 4),
('Karthik Raj', 'karthik@bank.com', 5),
('Divya Rao', 'divya@bank.com', 6),
('Vikram Singh', 'vikram@bank.com', 7),
('Meena Das', 'meena@bank.com', 8),
('Sanjay Kumar', 'sanjay@bank.com', 9),
('Anita Joseph', 'anita@bank.com', 10);
GO

-- 3. Insert Customers
INSERT INTO Customers
(CustomerName, AddressLine, City, State, PostalCode, Phone)
VALUES
('Customer 1', '12 Lake View Road', 'Chennai', 'Tamil Nadu', '600001', '9876500001'),
('Customer 2', '25 Gandhi Street', 'Chennai', 'Tamil Nadu', '600045', '9876500002'),
('Customer 3', '14 MG Road', 'Bangalore', 'Karnataka', '560001', '9876500003'),
('Customer 4', '32 Fort Street', 'Mumbai', 'Maharashtra', '400001', '9876500004'),
('Customer 5', '18 Park Lane', 'Delhi', 'Delhi', '110001', '9876500005'),
('Customer 6', '45 Tech Road', 'Hyderabad', 'Telangana', '500081', '9876500006'),
('Customer 7', '21 FC Road', 'Pune', 'Maharashtra', '411004', '9876500007'),
('Customer 8', '10 Park Street', 'Kolkata', 'West Bengal', '700016', '9876500008'),
('Customer 9', '8 RS Puram', 'Coimbatore', 'Tamil Nadu', '641002', '9876500009'),
('Customer 10', '16 KK Nagar', 'Madurai', 'Tamil Nadu', '625020', '9876500010');
GO

-- 4. Insert Accounts
INSERT INTO Accounts
(AccountNumber, AccountType, BranchID, ManagerID, Balance, OpenedDate)
VALUES
('ACC1001', 'Savings', 1, 1, 25000, '2026-08-05'),
('ACC1002', 'Current', 2, 2, 50000, '2026-08-12'),
('ACC1003', 'Savings', 3, 3, 15000, '2026-09-01'),
('ACC1004', 'Fixed Deposit', 4, 4, 100000, '2026-09-15'),
('ACC1005', 'Savings', 5, 5, 35000, '2026-10-02'),
('ACC1006', 'Current', 6, 6, 75000, '2026-10-10'),
('ACC1007', 'Savings', 7, 7, 12000, '2026-10-20'),
('ACC1008', 'Fixed Deposit', 8, 8, 150000, '2026-11-01'),
('ACC1009', 'Savings', 9, 9, 18000, '2026-11-05'),
('ACC1010', 'Current', 10, 10, 60000, '2026-11-10');
GO

-- 5. Insert Account Holders
INSERT INTO AccountHolders
(CustomerID, AccountID, OwnershipRole)
VALUES
(1, 1, 'Primary'),
(2, 2, 'Primary'),
(3, 3, 'Primary'),
(4, 4, 'Primary'),
(5, 5, 'Primary'),
(6, 6, 'Primary'),
(7, 7, 'Primary'),
(8, 8, 'Primary'),
(9, 9, 'Primary'),
(10, 10, 'Primary');
GO

-- Verify inserted records
SELECT * FROM Customers;
SELECT * FROM Branches;
SELECT * FROM RelationshipManagers;
SELECT * FROM Accounts;
SELECT * FROM AccountHolders;
GO


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
