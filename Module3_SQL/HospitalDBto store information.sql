-- Step 2: Create the Database
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- Step 3: Create the Tables
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100)
);

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    doctor_id INT
);

-- Step 4: Insert Sample Data
INSERT INTO Doctors (doctor_id, first_name, last_name, specialization)
VALUES
    (1, 'John', 'Peter', 'Cardiology'),
    (2, 'Piyush', 'Syam', 'Orthopedics'),
    (3, 'Ishan', 'Sha', 'Neurology');

INSERT INTO Patients (patient_id, first_name, last_name, age, doctor_id)
VALUES
    (101, 'Ameya', 'Sreekanth', 30, 1),
    (102, 'Taniya', 'Jane', 45, 2),
    (103, 'Rakesh', 'Sharma', 50, NULL);

-- A) Inner Join: Retrieve Patients with Their Doctors
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
INNER JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- B) Left Join: Retrieve All Patients and Their Doctors
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
LEFT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- C) Right Join: Retrieve All Doctors and Their Patients
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
RIGHT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- D) Full Outer Join: Retrieve All Matches and Non-Matches (simulated using UNION of LEFT and RIGHT JOIN)
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
LEFT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id
UNION
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
RIGHT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- E) Cross Join: Cartesian Product of Patients and Doctors
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name
FROM
    Patients
CROSS JOIN
    Doctors;

-- F) Self Join: Patients in the Same Department (requires adding a 'department' column first)
ALTER TABLE Patients ADD department VARCHAR(50);
-- Step 2: Create the Database
CREATE DATABASE HospitalDB;
USE HospitalDB;

-- Step 3: Create the Tables
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100)
);

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    doctor_id INT
);

-- Step 4: Insert Sample Data
INSERT INTO Doctors (doctor_id, first_name, last_name, specialization)
VALUES
    (1, 'John', 'Peter', 'Cardiology'),
    (2, 'Piyush', 'Syam', 'Orthopedics'),
    (3, 'Ishan', 'Sha', 'Neurology');

INSERT INTO Patients (patient_id, first_name, last_name, age, doctor_id)
VALUES
    (101, 'Ameya', 'Sreekanth', 30, 1),
    (102, 'Taniya', 'Jane', 45, 2),
    (103, 'Rakesh', 'Sharma', 50, NULL);

-- A) Inner Join: Retrieve Patients with Their Doctors
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
INNER JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- B) Left Join: Retrieve All Patients and Their Doctors
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
LEFT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- C) Right Join: Retrieve All Doctors and Their Patients
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
RIGHT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- D) Full Outer Join: Retrieve All Matches and Non-Matches (simulated using UNION of LEFT and RIGHT JOIN)
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
LEFT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id
UNION
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name,
    Doctors.specialization
FROM
    Patients
RIGHT JOIN
    Doctors
ON
    Patients.doctor_id = Doctors.doctor_id;

-- E) Cross Join: Cartesian Product of Patients and Doctors
SELECT
    Patients.first_name AS patient_name,
    Doctors.first_name AS doctor_name
FROM
    Patients
CROSS JOIN
    Doctors;

-- F) Self Join: Patients in the Same Department (requires adding a 'department' column first)
ALTER TABLE Patients ADD department VARCHAR(50);

UPDATE Patients
SET department = 'Cardiology'
WHERE doctor_id = 1;

UPDATE Patients
SET department = 'Orthopedics'
WHERE doctor_id = 2;

UPDATE Patients
SET department = 'General';

SELECT
    p1.first_name AS patient1_name,
    p2.first_name AS patient2_name,
    p1.department
FROM
    Patients p1
INNER JOIN
    Patients p2
ON
    p1.department = p2.department AND p1.patient_id != p2.patient_id;
    
SET SQL_SAFE_UPDATES = 0;
UPDATE Patients
SET department = 'Cardiology'
WHERE doctor_id = 1;

UPDATE Patients
SET department = 'Orthopedics'
WHERE doctor_id = 2;

UPDATE Patients
SET department = 'General';

SELECT
    p1.first_name AS patient1_name,
    p2.first_name AS patient2_name,
    p1.department
FROM
    Patients p1
INNER JOIN
    Patients p2
ON
    p1.department = p2.department AND p1.patient_id != p2.patient_id;