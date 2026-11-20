CREATE DATABASE RetailOrderDB;
GO

USE RetailOrderDB;
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT,
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2),
    StockQuantity INT,
    ReorderLevel INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 DEFAULT SYSDATETIME(),
    OrderStatus VARCHAR(30) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE OrderFollowUps (
    FollowUpID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    FollowUpDate DATETIME2 DEFAULT SYSDATETIME(),
    Remarks VARCHAR(255),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Customers (CustomerName, Email, Phone)
VALUES
('Arun Kumar', 'arun@example.com', '9876543210'),
('Priya Sharma', 'priya@example.com', '9876543211');

INSERT INTO Suppliers (SupplierName)
VALUES ('ABC Suppliers'), ('XYZ Distributors');

INSERT INTO Products
(ProductName, SupplierID, CostPrice, SellingPrice, StockQuantity, ReorderLevel)
VALUES
('Laptop', 1, 35000, 45000, 20, 5),
('Keyboard', 2, 500, 800, 4, 10),
('Mouse', 1, 250, 400, 30, 8);

INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
VALUES
(1, DATEADD(DAY, -5, SYSDATETIME()), 'Pending'),
(2, DATEADD(DAY, -1, SYSDATETIME()), 'Pending');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 1, 45000),
(1, 2, 2, 800),
(2, 3, 1, 400);
GO