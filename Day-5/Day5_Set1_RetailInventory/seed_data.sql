
USE RetailInventory;
GO

-- 1. Insert Suppliers
INSERT INTO Suppliers (SupplierName, Phone)
VALUES
('ABC Traders', '9876543210'),
('XYZ Suppliers', '9876543211'),
('Global Tech', '9876543212'),
('Prime Distributors', '9876543213'),
('Smart Supplies', '9876543214'),
('City Wholesale', '9876543215'),
('Elite Products', '9876543216'),
('National Traders', '9876543217'),
('Metro Suppliers', '9876543218'),
('Universal Goods', '9876543219');
GO

-- 2. Insert Categories
INSERT INTO Categories (CategoryName)
VALUES
('Electronics'),
('Furniture'),
('Clothing'),
('Books'),
('Home Appliances'),
('Sports'),
('Stationery'),
('Accessories'),
('Toys'),
('Kitchenware');
GO

-- 3. Insert Warehouses
INSERT INTO Warehouses (WarehouseName)
VALUES
('Chennai'),
('Bangalore'),
('Mumbai'),
('Delhi'),
('Hyderabad'),
('Pune'),
('Kolkata'),
('Coimbatore'),
('Madurai'),
('Kochi');
GO

-- 4. Insert Products
INSERT INTO Products
(SKU, ProductName, SupplierID, CategoryID, WarehouseID, Quantity, ReorderLevel)
VALUES
('P101', 'Laptop', 1, 1, 1, 20, 5),
('P102', 'Office Chair', 2, 2, 2, 15, 5),
('P103', 'T-Shirt', 3, 3, 3, 100, 20),
('P104', 'SQL Book', 4, 4, 4, 40, 10),
('P105', 'Refrigerator', 5, 5, 5, 12, 3),
('P106', 'Football', 6, 6, 6, 30, 8),
('P107', 'Notebook', 7, 7, 7, 200, 50),
('P108', 'Smart Watch', 8, 8, 8, 25, 5),
('P109', 'Toy Car', 9, 9, 9, 60, 15),
('P110', 'Mixer Grinder', 10, 10, 10, 18, 4);
GO

-- Verify the inserted records
SELECT * FROM Suppliers;
SELECT * FROM Categories;
SELECT * FROM Warehouses;
SELECT * FROM Products;
GO


USE RetailInventory;
GO

-- FAILURE 1: Duplicate Primary Key
INSERT INTO Products
(SKU, ProductName, SupplierID, CategoryID, WarehouseID, Quantity, ReorderLevel)
VALUES
('P101', 'Duplicate Laptop', 1, 1, 1, 10, 5);
GO

-- FAILURE 2: Missing Parent Record
INSERT INTO Products
(SKU, ProductName, SupplierID, CategoryID, WarehouseID, Quantity, ReorderLevel)
VALUES
('P111', 'Gaming Laptop', 999, 1, 1, 10, 5);
GO

-- FAILURE 3: Negative Quantity
INSERT INTO Products
(SKU, ProductName, SupplierID, CategoryID, WarehouseID, Quantity, ReorderLevel)
VALUES
('P112', 'Wireless Mouse', 1, 1, 1, -5, 2);
GO

-- FAILURE 4: NULL in Mandatory Column
INSERT INTO Suppliers
(SupplierName, Phone)
VALUES
(NULL, '9876500000');
GO


USE RetailInventory;
GO

-- BEFORE UPDATE
SELECT * FROM Suppliers
WHERE SupplierID = 1;
GO

-- UPDATE supplier phone number
UPDATE Suppliers
SET Phone = '9999999999'
WHERE SupplierID = 1;
GO

-- AFTER UPDATE
SELECT * FROM Suppliers
WHERE SupplierID = 1;
GO


-- BEFORE DELETE
SELECT * FROM Products
WHERE SKU = 'P110';
GO

-- DELETE discontinued product
DELETE FROM Products
WHERE SKU = 'P110';
GO

-- AFTER DELETE
SELECT * FROM Products
WHERE SKU = 'P110';
GO
