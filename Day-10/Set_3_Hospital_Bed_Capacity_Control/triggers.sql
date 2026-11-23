-- Day 10 - Set 3: Hospital Bed Capacity Control
-- SQL Server 2025

-- 1. Create database
IF DB_ID('HospitalBedControlDB') IS NULL
    CREATE DATABASE HospitalBedControlDB;
GO

USE HospitalBedControlDB;
GO

-- 2. Create wards table
IF OBJECT_ID('dbo.wards', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.wards
    (
        ward_id INT PRIMARY KEY,
        ward_name VARCHAR(100) NOT NULL,
        bed_capacity INT NOT NULL,
        occupied_beds INT NOT NULL DEFAULT 0,

        CONSTRAINT CK_wards_capacity
        CHECK (
            bed_capacity >= 0
            AND occupied_beds >= 0
            AND occupied_beds <= bed_capacity
        )
    );
END;
GO

-- 3. Create admissions table
IF OBJECT_ID('dbo.admissions', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.admissions
    (
        admission_id INT PRIMARY KEY,
        patient_name VARCHAR(100) NOT NULL,
        ward_id INT NOT NULL,
        admission_date DATETIME2 DEFAULT SYSDATETIME(),

        CONSTRAINT FK_admissions_wards
        FOREIGN KEY (ward_id)
        REFERENCES dbo.wards(ward_id)
    );
END;
GO

-- 4. Create admission audit table
IF OBJECT_ID('dbo.admission_audit', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.admission_audit
    (
        audit_id INT IDENTITY(1,1) PRIMARY KEY,
        admission_id INT,
        patient_name VARCHAR(100),
        ward_id INT,
        action_type VARCHAR(10),
        changed_by VARCHAR(128),
        changed_at DATETIME2 DEFAULT SYSDATETIME()
    );
END;
GO

-- 5. Insert sample wards
IF NOT EXISTS (SELECT 1 FROM dbo.wards)
BEGIN
    INSERT INTO dbo.wards
        (ward_id, ward_name, bed_capacity, occupied_beds)
    VALUES
        (1, 'General Ward', 3, 0),
        (2, 'ICU', 2, 0),
        (3, 'Emergency Ward', 4, 0);
END;
GO

-- 6. Create admission capacity trigger
-- Checks the total number of admissions per ward.
-- Rejects the entire INSERT statement if any ward exceeds capacity.

CREATE OR ALTER TRIGGER dbo.trg_check_bed_capacity
ON dbo.admissions
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT i.ward_id
        FROM inserted i
        GROUP BY i.ward_id
        HAVING
        (
            SELECT COUNT(*)
            FROM dbo.admissions a
            WHERE a.ward_id = i.ward_id
        )
        +
        (
            SELECT COUNT(*)
            FROM inserted new_rows
            WHERE new_rows.ward_id = i.ward_id
        )
        >
        (
            SELECT w.bed_capacity
            FROM dbo.wards w
            WHERE w.ward_id = i.ward_id
        )
    )
    BEGIN
        THROW 50002,
              'Admission rejected: ward bed capacity exceeded.',
              1;
    END;

    INSERT INTO dbo.admissions
        (admission_id, patient_name, ward_id, admission_date)
    SELECT
        admission_id,
        patient_name,
        ward_id,
        admission_date
    FROM inserted;
END;
GO

-- 7. AFTER INSERT, UPDATE, DELETE audit trigger
CREATE OR ALTER TRIGGER dbo.trg_admission_audit
ON dbo.admissions
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.admission_audit
    (
        admission_id,
        patient_name,
        ward_id,
        action_type,
        changed_by,
        changed_at
    )
    SELECT
        COALESCE(i.admission_id, d.admission_id),
        COALESCE(i.patient_name, d.patient_name),
        COALESCE(i.ward_id, d.ward_id),
        CASE
            WHEN d.admission_id IS NULL THEN 'INSERT'
            WHEN i.admission_id IS NULL THEN 'DELETE'
            ELSE 'UPDATE'
        END,
        SUSER_SNAME(),
        SYSDATETIME()
    FROM inserted i
    FULL OUTER JOIN deleted d
        ON i.admission_id = d.admission_id;
END;
GO