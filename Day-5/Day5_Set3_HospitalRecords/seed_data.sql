
USE HospitalPatientRecords;
GO

-- 1. Insert Departments
INSERT INTO Departments (DepartmentName, Location)
VALUES
('Cardiology', 'Block A'),
('Neurology', 'Block B'),
('Orthopedics', 'Block C'),
('Pediatrics', 'Block D'),
('Dermatology', 'Block E');
GO

-- 2. Insert Doctors
INSERT INTO Doctors (DoctorName, Specialization, DepartmentID)
VALUES
('Dr. Arun Kumar', 'Heart Specialist', 1),
('Dr. Priya Sharma', 'Neurologist', 2),
('Dr. Rahul Verma', 'Bone Specialist', 3),
('Dr. Sneha Patel', 'Child Specialist', 4),
('Dr. Karthik Raj', 'Skin Specialist', 5),
('Dr. Divya Rao', 'Cardiologist', 1);
GO

-- 3. Insert Patients
INSERT INTO Patients
(PatientName, DateOfBirth, Gender, AddressLine, City, Phone)
VALUES
('Ananya', '1995-04-12', 'Female', '12 Lake View Road', 'Chennai', '9876500001'),
('Ravi', '1988-07-20', 'Male', '25 Gandhi Street', 'Chennai', '9876500002'),
('Meera', '2000-01-15', 'Female', '14 MG Road', 'Bangalore', '9876500003'),
('Arjun', '1992-09-05', 'Male', '32 Fort Street', 'Mumbai', '9876500004'),
('Kavya', '2010-03-18', 'Female', '18 Park Lane', 'Delhi', '9876500005'),
('Vikram', '1985-11-25', 'Male', '45 Tech Road', 'Hyderabad', '9876500006'),
('Divya', '1998-06-30', 'Female', '21 FC Road', 'Pune', '9876500007'),
('Sanjay', '1979-02-10', 'Male', '10 Park Street', 'Kolkata', '9876500008'),
('Nisha', '2002-12-01', 'Female', '8 RS Puram', 'Coimbatore', '9876500009'),
('Kiran', '1990-08-14', 'Male', '16 KK Nagar', 'Madurai', '9876500010');
GO

-- 4. Insert Visits
INSERT INTO Visits
(PatientID, DoctorID, VisitDate, Diagnosis, Prescription, Status)
VALUES
(1, 1, '2026-10-05', 'Hypertension', 'Blood pressure medication', 'Open'),
(2, 2, '2026-10-08', 'Migraine', 'Pain relief medication', 'Closed'),
(3, 3, '2026-10-12', 'Knee pain', 'Physiotherapy', 'Open'),
(4, 4, '2026-11-02', 'Common cold', 'Rest and fluids', 'Closed'),
(5, 4, '2026-11-05', 'Fever', 'Paracetamol', 'Open'),
(6, 1, '2026-09-15', 'Chest discomfort', 'ECG and follow-up', 'Closed'),
(7, 5, '2026-11-10', 'Skin allergy', 'Antihistamine', 'Open'),
(8, 2, '2026-10-20', 'Headache', 'Medication and rest', 'Closed'),
(9, 3, '2026-09-22', 'Back pain', 'Physiotherapy', 'Open'),
(10, 6, '2026-11-12', 'Arrhythmia', 'Cardiac evaluation', 'Open');
GO

-- 5. Insert Billing records
INSERT INTO Billing (VisitID, BillAmount, PaymentStatus)
VALUES
(1, 2500, 'Pending'),
(2, 1500, 'Paid'),
(3, 3000, 'Pending'),
(4, 800, 'Paid'),
(5, 1200, 'Pending'),
(6, 4500, 'Paid'),
(7, 1800, 'Pending'),
(8, 1000, 'Paid'),
(9, 2200, 'Pending'),
(10, 5000, 'Pending');
GO

-- Verify inserted records
SELECT * FROM Patients;
SELECT * FROM Departments;
SELECT * FROM Doctors;
SELECT * FROM Visits;
SELECT * FROM Billing;
GO
