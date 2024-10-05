CREATE SCHEMA medical_records;

CREATE TABLE medical_records.Patient (
    patient_id SERIAL PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(8) NOT NULL  CHECK (gender = 'Male' or gender = 'Female'),
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE medical_records.Doctor (
    doctor_id SERIAL PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR NOT NULL,
    license_number VARCHAR NOT NULL
);

CREATE TABLE medical_records.Appointment (
    appointment_id SERIAL PRIMARY KEY NOT NULL,
    date_and_time TIMESTAMP NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES medical_records.Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES medical_records.Doctor(doctor_id)
);

CREATE TABLE medical_records.Diagnosis (
    diagnosis_id SERIAL PRIMARY KEY NOT NULL,
    appointment_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    update_ddtt TIMESTAMP NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES medical_records.Appointment(appointment_id)
);

CREATE TABLE medical_records.Prescription (
    prescription_ID SERIAL PRIMARY KEY NOT NULL,
    appointment_id INT NOT NULL,
    medication VARCHAR(255) NOT NULL,
    dosage VARCHAR(255) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES medical_records.Appointment(appointment_id)
);

CREATE TABLE medical_records.Medical_Leave (
    medical_leave_id SERIAL PRIMARY KEY NOT NULL,
    appointment_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (appointment_id) REFERENCES medical_records.Appointment(appointment_id)
);
