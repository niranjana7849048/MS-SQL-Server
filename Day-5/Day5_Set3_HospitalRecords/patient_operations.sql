
USE HospitalPatientRecords;
GO

-- 1. INSERT a new patient
INSERT INTO Patients
(PatientName, DateOfBirth, Gender, AddressLine, City, Phone, insurance_id)
VALUES
('Rahul', '1996-05-15', 'Male', '22 Anna Nagar', 'Chennai', '9876500011', 'INS1001');

SELECT * FROM Patients
WHERE PatientName = 'Rahul';
GO

-- 2. UPDATE patient phone number
UPDATE Patients
SET Phone = '9999900011'
WHERE PatientName = 'Rahul';

SELECT * FROM Patients
WHERE PatientName = 'Rahul';
GO

-- 3. INSERT a visit for the new patient
INSERT INTO Visits
(PatientID, DoctorID, VisitDate, Diagnosis, Prescription)
VALUES
(11, 1, '2026-11-15', 'High blood pressure', 'Regular monitoring');

SELECT * FROM Visits
WHERE PatientID = 11;
GO

-- 4. INSERT billing for the new visit
INSERT INTO VisitBilling (VisitID, BillAmount, PaymentStatus)
VALUES (11, 2800, 'Pending');

SELECT * FROM VisitBilling
WHERE VisitID = 11;
GO

-- 5. DELETE the test visit
DELETE FROM Visits
WHERE VisitID = 11;

-- Verify billing was also deleted through CASCADE
SELECT * FROM VisitBilling
WHERE VisitID = 11;
GO

-- 6. DELETE the test patient
DELETE FROM Patients
WHERE PatientID = 11;

SELECT * FROM Patients
WHERE PatientID = 11;
GO

-- 7. Retrieve patients visited in November 2026
SELECT
    P.PatientID,
    P.PatientName,
    V.VisitDate,
    V.Diagnosis
FROM Patients P
JOIN Visits V ON P.PatientID = V.PatientID
WHERE V.VisitDate >= '2026-11-01'
  AND V.VisitDate < '2026-12-01';
GO

-- 8. Retrieve doctors in departments containing 'Cardio'
SELECT
    D.DoctorName,
    D.Specialization,
    DP.DepartmentName
FROM Doctors D
JOIN Departments DP
    ON D.DepartmentID = DP.DepartmentID
WHERE DP.DepartmentName LIKE '%Cardio%';
GO
