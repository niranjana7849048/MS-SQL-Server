-- Day 10 - Set 1: Retail Price Change Audit
-- SQL Server 2025

-- 1. Create database
IF DB_ID('RetailPriceAuditDB') IS NULL
    CREATE DATABASE RetailPriceAuditDB;
GO

USE RetailPriceAuditDB;
GO

-- 2. Create product_price table
IF OBJECT_ID('dbo.product_price', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.product_price
    (
        product_id INT PRIMARY KEY,
        product_name VARCHAR(100) NOT NULL,
        cost_price DECIMAL(10,2) NOT NULL,
        selling_price DECIMAL(10,2) NOT NULL
    );
END;
GO

-- 3. Create price_audit table
IF OBJECT_ID('dbo.price_audit', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.price_audit
    (
        audit_id INT IDENTITY(1,1) PRIMARY KEY,
        product_id INT,
        old_price DECIMAL(10,2),
        new_price DECIMAL(10,2),
        changed_by VARCHAR(128),
        changed_at DATETIME2 DEFAULT SYSDATETIME()
    );
END;
GO

-- 4. Create rejected_price_attempt table
IF OBJECT_ID('dbo.rejected_price_attempt', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.rejected_price_attempt
    (
        attempt_id INT IDENTITY(1,1) PRIMARY KEY,
        product_id INT,
        attempted_price DECIMAL(10,2),
        cost_price DECIMAL(10,2),
        attempted_by VARCHAR(128),
        attempted_at DATETIME2 DEFAULT SYSDATETIME(),
        reason VARCHAR(200)
    );
END;
GO

-- 5. Insert sample products
IF NOT EXISTS (SELECT 1 FROM dbo.product_price)
BEGIN
    INSERT INTO dbo.product_price
        (product_id, product_name, cost_price, selling_price)
    VALUES
        (1, 'Laptop', 40000, 45000),
        (2, 'Keyboard', 500, 750),
        (3, 'Mouse', 200, 350),
        (4, 'Monitor', 8000, 9500),
        (5, 'Headphones', 1000, 1500);
END;
GO

-- 6. AFTER UPDATE trigger
-- Records every successful price change.
CREATE OR ALTER TRIGGER dbo.trg_price_after_update
ON dbo.product_price
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.price_audit
        (product_id, old_price, new_price, changed_by, changed_at)
    SELECT
        d.product_id,
        d.selling_price,
        i.selling_price,
        SUSER_SNAME(),
        SYSDATETIME()
    FROM inserted i
    INNER JOIN deleted d
        ON i.product_id = d.product_id
    WHERE i.selling_price <> d.selling_price;
END;
GO

-- 7. INSTEAD OF UPDATE trigger
-- Rejects prices below cost and logs rejected attempts.
-- Valid rows in the same batch are still updated.
CREATE OR ALTER TRIGGER dbo.trg_price_instead_update
ON dbo.product_price
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log rejected attempts
    INSERT INTO dbo.rejected_price_attempt
        (product_id, attempted_price, cost_price,
         attempted_by, attempted_at, reason)
    SELECT
        i.product_id,
        i.selling_price,
        i.cost_price,
        SUSER_SNAME(),
        SYSDATETIME(),
        'Selling price cannot be below cost price'
    FROM inserted i
    WHERE i.selling_price < i.cost_price;

    -- Update only valid rows
    UPDATE p
    SET
        p.product_name = i.product_name,
        p.cost_price = i.cost_price,
        p.selling_price = i.selling_price
    FROM dbo.product_price p
    INNER JOIN inserted i
        ON p.product_id = i.product_id
    WHERE i.selling_price >= i.cost_price;
END;
GO