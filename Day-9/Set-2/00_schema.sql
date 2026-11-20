CREATE DATABASE InsuranceDB;
GO

USE InsuranceDB;
GO

-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

-- Agents table
CREATE TABLE Agents (
    AgentID INT PRIMARY KEY IDENTITY(1,1),
    AgentName VARCHAR(100) NOT NULL
);

-- Policies table
CREATE TABLE Policies (
    PolicyID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    AgentID INT NOT NULL,
    PolicyType VARCHAR(50),
    PremiumAmount DECIMAL(10,2),
    RenewalDate DATE,
    PolicyStatus VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);

-- Claims table
CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY IDENTITY(1,1),
    PolicyID INT NOT NULL,
    ClaimStatus VARCHAR(30),
    ClaimAmount DECIMAL(10,2),
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

-- Renewal audit table
CREATE TABLE RenewalAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    PolicyID INT NOT NULL,
    OldPremium DECIMAL(10,2),
    NewPremium DECIMAL(10,2),
    RenewalDate DATE,
    AuditDate DATETIME2 DEFAULT SYSDATETIME(),
    Remarks VARCHAR(255),
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

-- Lapse log table
CREATE TABLE PolicyLapseLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    PolicyID INT NOT NULL,
    PreviousStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    LogDate DATETIME2 DEFAULT SYSDATETIME(),
    Remarks VARCHAR(255),
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

-- Sample customers
INSERT INTO Customers (CustomerName, Email, Phone)
VALUES
('Rahul Kumar', 'rahul@example.com', '9876543210'),
('Ananya Sharma', 'ananya@example.com', '9876543211'),
('Vikram Raj', 'vikram@example.com', '9876543212');

-- Sample agents
INSERT INTO Agents (AgentName)
VALUES
('Agent Ravi'),
('Agent Priya');

-- Sample policies
INSERT INTO Policies
(CustomerID, AgentID, PolicyType, PremiumAmount, RenewalDate, PolicyStatus)
VALUES
(1, 1, 'Health', 12000, DATEADD(DAY, 10, CAST(GETDATE() AS DATE)), 'Active'),
(2, 1, 'Life', 15000, DATEADD(DAY, 20, CAST(GETDATE() AS DATE)), 'Active'),
(3, 2, 'Vehicle', 8000, DATEADD(DAY, -10, CAST(GETDATE() AS DATE)), 'Active'),
(1, 2, 'Health', 10000, DATEADD(DAY, -5, CAST(GETDATE() AS DATE)), 'Active'),
(2, 1, 'Life', 18000, DATEADD(DAY, 60, CAST(GETDATE() AS DATE)), 'Active');

-- Sample claims
INSERT INTO Claims (PolicyID, ClaimStatus, ClaimAmount)
VALUES
(1, 'Approved', 5000),
(2, 'Pending', 3000),
(3, 'Rejected', 2000),
(4, 'Approved', 4000);

GO