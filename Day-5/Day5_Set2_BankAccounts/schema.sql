
CREATE DATABASE BankBranchAccounts;
GO

USE BankBranchAccounts;
GO

-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    AddressLine VARCHAR(200) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    Phone VARCHAR(15) NOT NULL
);
GO

-- 2. Branches Table
CREATE TABLE Branches (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL UNIQUE,
    BranchAddress VARCHAR(200) NOT NULL,
    City VARCHAR(50) NOT NULL
);
GO

-- 3. Relationship Managers Table
CREATE TABLE RelationshipManagers (
    ManagerID INT IDENTITY(1,1) PRIMARY KEY,
    ManagerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    BranchID INT NOT NULL,

    CONSTRAINT FK_Manager_Branch
        FOREIGN KEY (BranchID)
        REFERENCES Branches(BranchID)
        ON DELETE NO ACTION,

    CONSTRAINT UQ_Manager_Branch
        UNIQUE (ManagerID, BranchID)
);
GO

-- 4. Accounts Table
CREATE TABLE Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    AccountType VARCHAR(20) NOT NULL,
    BranchID INT NOT NULL,
    ManagerID INT NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    OpenedDate DATE NOT NULL DEFAULT GETDATE(),

    CONSTRAINT CK_Account_Type
        CHECK (AccountType IN ('Savings', 'Current', 'Fixed Deposit')),

    CONSTRAINT CK_Savings_Balance
        CHECK (AccountType <> 'Savings' OR Balance >= 0),

    CONSTRAINT FK_Account_Branch
        FOREIGN KEY (BranchID)
        REFERENCES Branches(BranchID)
        ON DELETE NO ACTION,

    CONSTRAINT FK_Account_Manager_Branch
        FOREIGN KEY (ManagerID, BranchID)
        REFERENCES RelationshipManagers(ManagerID, BranchID)
        ON DELETE NO ACTION
);
GO

-- 5. Account Holders Table
CREATE TABLE AccountHolders (
    CustomerID INT NOT NULL,
    AccountID INT NOT NULL,
    OwnershipRole VARCHAR(20) NOT NULL DEFAULT 'Primary',
    OwnershipStartDate DATE NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_AccountHolders
        PRIMARY KEY (CustomerID, AccountID),

    CONSTRAINT FK_Holder_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Holder_Account
        FOREIGN KEY (AccountID)
        REFERENCES Accounts(AccountID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Ownership_Role
        CHECK (OwnershipRole IN ('Primary', 'Joint'))
);
GO

USE BankBranchAccounts;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';