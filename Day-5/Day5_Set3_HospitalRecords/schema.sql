
CREATE DATABASE HospitalPatientRecords;
GO

USE HospitalPatientRecords;
GO

-- 1. Patients
CREATE TABLE Patients (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    AddressLine VARCHAR(200) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,

    CONSTRAINT CK_Patient_Gender
        CHECK (Gender IN ('Male', 'Female', 'Other'))
);
GO

-- 2. Departments
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100) NOT NULL
);
GO

-- 3. Doctors
CREATE TABLE Doctors (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,

    CONSTRAINT FK_Doctor_Department
        FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID)
        ON DELETE NO ACTION
);
GO

-- 4. Visits
CREATE TABLE Visits (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR(200) NOT NULL,
    Prescription VARCHAR(500),
    Status VARCHAR(20) NOT NULL DEFAULT 'Open',

    CONSTRAINT FK_Visit_Patient
        FOREIGN KEY (PatientID)
        REFERENCES Patients(PatientID)
        ON DELETE NO ACTION,

    CONSTRAINT FK_Visit_Doctor
        FOREIGN KEY (DoctorID)
        REFERENCES Doctors(DoctorID)
        ON DELETE NO ACTION,

    CONSTRAINT CK_Visit_Date
        CHECK (VisitDate <= CAST(GETDATE() AS DATE)),

    CONSTRAINT CK_Visit_Status
        CHECK (Status IN ('Open', 'Closed', 'Cancelled'))
);
GO

-- 5. Billing
CREATE TABLE Billing (
    BillingID INT IDENTITY(1,1) PRIMARY KEY,
    VisitID INT NOT NULL UNIQUE,
    BillAmount DECIMAL(12,2) NOT NULL DEFAULT 0,
    PaymentStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_Billing_Visit
        FOREIGN KEY (VisitID)
        REFERENCES Visits(VisitID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Bill_Amount
        CHECK (BillAmount >= 0),

    CONSTRAINT CK_Payment_Status
        CHECK (PaymentStatus IN ('Pending', 'Paid', 'Partially Paid'))
);
GO
