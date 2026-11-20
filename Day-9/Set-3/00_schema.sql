CREATE DATABASE TelecomDB;
GO

USE TelecomDB;
GO

-- Subscribers table
CREATE TABLE Subscribers (
    SubscriberID INT PRIMARY KEY IDENTITY(1,1),
    SubscriberName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15),
    SubscriberType VARCHAR(20) NOT NULL,
    Balance DECIMAL(10,2) DEFAULT 0,
    ValidityEndDate DATE
);

-- Recharge plans
CREATE TABLE RechargePlans (
    PlanID INT PRIMARY KEY IDENTITY(1,1),
    PlanName VARCHAR(100),
    RechargeAmount DECIMAL(10,2),
    ValidityDays INT
);

-- Recharge history
CREATE TABLE RechargeHistory (
    RechargeID INT PRIMARY KEY IDENTITY(1,1),
    SubscriberID INT NOT NULL,
    PlanID INT NOT NULL,
    RechargeAmount DECIMAL(10,2),
    RechargeDate DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID),
    FOREIGN KEY (PlanID) REFERENCES RechargePlans(PlanID)
);

-- Notification log
CREATE TABLE NotificationLog (
    NotificationID INT PRIMARY KEY IDENTITY(1,1),
    SubscriberID INT NOT NULL,
    Message VARCHAR(255),
    IsRead BIT DEFAULT 0,
    NotificationDate DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID)
);

-- Sample subscribers
INSERT INTO Subscribers
(SubscriberName, PhoneNumber, SubscriberType, Balance, ValidityEndDate)
VALUES
('Arun Kumar', '9876543210', 'Prepaid', 25, DATEADD(DAY, 20, CAST(GETDATE() AS DATE))),
('Priya Sharma', '9876543211', 'Prepaid', 150, DATEADD(DAY, 30, CAST(GETDATE() AS DATE))),
('Rahul Raj', '9876543212', 'Postpaid', 0, DATEADD(DAY, 30, CAST(GETDATE() AS DATE))),
('Divya Kumar', '9876543213', 'Prepaid', 40, DATEADD(DAY, 10, CAST(GETDATE() AS DATE))),
('Karthik S', '9876543214', 'Prepaid', 75, DATEADD(DAY, 15, CAST(GETDATE() AS DATE)));

-- Sample recharge plans
INSERT INTO RechargePlans (PlanName, RechargeAmount, ValidityDays)
VALUES
('Basic', 50, 28),
('Standard', 100, 56),
('Premium', 200, 84);

-- Sample recharge history
INSERT INTO RechargeHistory
(SubscriberID, PlanID, RechargeAmount)
VALUES
(1, 1, 50),
(1, 2, 100),
(2, 3, 200),
(4, 1, 50),
(5, 2, 100);

GO