
USE BankBranchAccounts;
GO

-- Create a test table
CREATE TABLE IdentityTest (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50)
);
GO

INSERT INTO IdentityTest (Name)
VALUES ('A'), ('B'), ('C');
GO

-- 1. DELETE: Test rollback
BEGIN TRANSACTION;

DELETE FROM IdentityTest WHERE ID = 2;

SELECT * FROM IdentityTest;

ROLLBACK TRANSACTION;

-- Verify deleted row is restored
SELECT * FROM IdentityTest;
GO

-- DELETE: Test identity value
DELETE FROM IdentityTest;

INSERT INTO IdentityTest (Name)
VALUES ('D');

SELECT * FROM IdentityTest;
-- Expected ID: 4 (identity is not reset)
GO

-- 2. TRUNCATE: Test rollback
BEGIN TRANSACTION;

TRUNCATE TABLE IdentityTest;

SELECT * FROM IdentityTest;

ROLLBACK TRANSACTION;

-- Verify rows are restored
SELECT * FROM IdentityTest;
GO

-- TRUNCATE: Test identity reset
TRUNCATE TABLE IdentityTest;

INSERT INTO IdentityTest (Name)
VALUES ('E');

SELECT * FROM IdentityTest;
-- Expected ID: 1
GO

-- 3. DROP: Test rollback
BEGIN TRANSACTION;

DROP TABLE IdentityTest;

SELECT OBJECT_ID('IdentityTest') AS TableAfterDrop;

ROLLBACK TRANSACTION;

-- Verify table is restored
SELECT * FROM IdentityTest;
GO

-- DROP: Permanently remove test table
DROP TABLE IdentityTest;

SELECT OBJECT_ID('IdentityTest') AS TableAfterDrop;
-- Expected: NULL
GO
