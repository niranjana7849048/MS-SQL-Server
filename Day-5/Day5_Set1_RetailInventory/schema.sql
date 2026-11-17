CREATE DATABASE RetailInventory;
GO

USE RetailInventory;
GO

SELECT name
FROM sys.databases
WHERE name = 'RetailInventory';


USE RetailInventory;
GO

-- 1. Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL
);
GO

-- 2. Categories Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);
GO

-- 3. Warehouses Table
CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName VARCHAR(100) NOT NULL UNIQUE
);
GO

-- 4. Products Table
CREATE TABLE Products (
    SKU VARCHAR(20) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    SupplierID INT NOT NULL,
    CategoryID INT NOT NULL,
    WarehouseID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 0 CHECK (Quantity >= 0),
    ReorderLevel INT NOT NULL DEFAULT 5 CHECK (ReorderLevel >= 0),

    CONSTRAINT FK_Products_Suppliers
        FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID)
        ON DELETE NO ACTION,

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
        ON DELETE NO ACTION,

    CONSTRAINT FK_Products_Warehouses
        FOREIGN KEY (WarehouseID)
        REFERENCES Warehouses(WarehouseID)
        ON DELETE NO ACTION
);
GO