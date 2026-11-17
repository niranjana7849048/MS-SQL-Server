
USE HospitalPatientRecords;
GO

-- 1. Add insurance_id column to Patients
ALTER TABLE Patients
ADD insurance_id VARCHAR(30) NULL;
GO

-- Verify new column
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Patients';
GO

-- 2. Rename Billing table to VisitBilling
EXEC sp_rename 'Billing', 'VisitBilling';
GO

-- Verify renamed table
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'VisitBilling';
GO

-- 3. Drop the gender constraint
ALTER TABLE Patients
DROP CONSTRAINT CK_Patient_Gender;
GO

-- Verify dropped constraint
SELECT name
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID('Patients');
GO
