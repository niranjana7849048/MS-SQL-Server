-- Day 10 - Set 3: Hospital Bed Capacity Control
-- Test Evidence

USE HospitalBedControlDB;
GO

-- TEST 1: View ward capacity
SELECT * FROM dbo.wards;
GO

-- TEST 2: Insert admissions within capacity
INSERT INTO dbo.admissions
    (admission_id, patient_name, ward_id)
VALUES
    (101, 'Patient A', 1),
    (102, 'Patient B', 1);
GO

SELECT * FROM dbo.admissions;
SELECT * FROM dbo.admission_audit;
GO

-- TEST 3: Attempt multi-row insert
-- General Ward capacity is 3.
-- Two patients are already admitted.
-- One additional patient is allowed, but the second exceeds capacity.
-- Entire INSERT statement should be rejected.

BEGIN TRY
    INSERT INTO dbo.admissions
        (admission_id, patient_name, ward_id)
    VALUES
        (103, 'Patient C', 1),
        (104, 'Patient D', 1);

    PRINT 'Admissions inserted successfully.';
END TRY
BEGIN CATCH
    PRINT 'Admission batch rejected.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- Verify that neither patient was admitted
SELECT * FROM dbo.admissions
WHERE ward_id = 1;
GO

-- TEST 4: Insert one admission within remaining capacity
INSERT INTO dbo.admissions
    (admission_id, patient_name, ward_id)
VALUES
    (105, 'Patient E', 1);
GO

SELECT * FROM dbo.admissions
WHERE ward_id = 1;
GO

-- TEST 5: Attempt admission when ward is full
BEGIN TRY
    INSERT INTO dbo.admissions
        (admission_id, patient_name, ward_id)
    VALUES
        (106, 'Patient F', 1);
END TRY
BEGIN CATCH
    PRINT 'Admission rejected because ward is full.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- TEST 6: Update an admission
UPDATE dbo.admissions
SET patient_name = 'Patient A Updated'
WHERE admission_id = 101;
GO

-- TEST 7: Delete an admission
DELETE FROM dbo.admissions
WHERE admission_id = 102;
GO

-- TEST 8: View final admissions
SELECT * FROM dbo.admissions
ORDER BY admission_id;
GO

-- TEST 9: Verify audit records
SELECT * FROM dbo.admission_audit
ORDER BY audit_id;
GO
