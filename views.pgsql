
-- Представление для связи между пациентами и их приемами:
CREATE VIEW medical_records.Patient_Appointment_View AS
SELECT
    p.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.date_of_birth,
    p.gender,
    p.address,
    p.phone_number,
    p.email,
    a.appointment_id,
    a.date_and_time,
    d.doctor_id,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    d.specialization
FROM
    medical_records.Patient p
    JOIN medical_records.Appointment a ON p.patient_id = a.patient_id
    JOIN medical_records.Doctor d ON a.doctor_id = d.doctor_id;
/*
Это представление предоставляет информацию о диагнозах
и соответствующих назначениях для каждого приема,
что упрощает анализ медицинских данных и обеспечивает
лучшее понимание состояния пациентов.
*/





-- Представление для анализа диагнозов и назначений:
CREATE VIEW medical_records.Diagnosis_Prescription_View AS
SELECT
    a.appointment_id,
    a.date_and_time,
    d.description AS diagnosis_description,
    p.medication,
    p.dosage,
    p.valid_from AS prescription_valid_from,
    p.valid_to AS prescription_valid_to
FROM
    medical_records.Appointment a
    LEFT JOIN medical_records.Diagnosis d ON a.appointment_id = d.appointment_id
    LEFT JOIN medical_records.Prescription p ON a.appointment_id = p.appointment_id;
/*
Это представление объединяет информацию о пациентах,
их приемах и соответствующих врачах для более удобного доступа
к этим данным без необходимости многократного объединения таблиц.
*/



-- Представление для отслеживания медицинских отпусков: 
CREATE VIEW medical_records.Medical_Leave_View AS
SELECT
    p.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    ml.start_date AS leave_start_date,
    ml.end_date AS leave_end_date
FROM
    medical_records.Patient p
    JOIN medical_records.Appointment a ON p.patient_id = a.patient_id
    JOIN medical_records.Medical_Leave ml ON a.appointment_id = ml.appointment_id;
/*
Это представление помогает отслеживать медицинские отпуска
пациентов и предоставляет информацию о датах начала и окончания
отпуска для каждого пациента.
*/