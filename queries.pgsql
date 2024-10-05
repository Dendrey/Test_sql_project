-- Вывести всех пациентов рождённых после 1990 года
SELECT * FROM medical_records.patient
WHERE date_of_birth > '1990-01-01';


-- Посчитать число приёмов для каждого врача

SELECT doctor_id, COUNT(appointment_id) AS num_appointments
FROM medical_records.Appointment
GROUP BY doctor_id;


-- Список врачей с их суммарным числом приёмов

SELECT d.first_name, d.last_name, COUNT(a.appointment_id) AS num_appointments
FROM medical_records.Doctor d
JOIN medical_records.Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

-- Вывести непросроченные рецепты в порядке даты выдачи
SELECT *
FROM medical_records.Prescription
WHERE valid_to > now()
ORDER BY valid_from DESC;

-- Вывести список посещений для всех пациентов
SELECT a.appointment_id, p.first_name, p.last_name, d.first_name, d.last_name, d.specialization, a.date_and_time
FROM medical_records.Patient p
JOIN medical_records.Appointment a ON p.patient_id = a.patient_id
JOIN medical_records.doctor d ON d.doctor_id = a.doctor_id;


-- Вывести список пациентов посещавших врача выбранной специальности
SELECT p.first_name, p.last_name, a.date_and_time
FROM medical_records.Patient p
JOIN medical_records.Appointment a ON p.patient_id = a.patient_id
JOIN medical_records.doctor d ON d.doctor_id = a.doctor_id
WHERE d.specialization = 'Endocrinology'; -- Specify the doctor cpecialization here


--Вывести последний поставленный диагноз для каждого пациента
WITH LastDiagnosis AS (
    SELECT
        d.appointment_id,
        d.description,
        d.update_ddtt,
        ROW_NUMBER() OVER (PARTITION BY a.patient_id ORDER BY d.update_ddtt DESC) AS rn
    FROM medical_records.Diagnosis d
    INNER JOIN medical_records.Appointment a ON d.appointment_id = a.appointment_id
)
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    ld.description AS last_diagnosis,
    ld.update_ddtt AS last_diagnosis_date
FROM medical_records.Patient p
LEFT JOIN medical_records.Appointment a ON p.patient_id = a.patient_id
LEFT JOIN LastDiagnosis ld ON a.appointment_id = ld.appointment_id AND ld.rn = 1
WHERE ld.description IS NOT  NULL;


--Вывести последний полученнный рецепт для каждого пациента
SELECT p.first_name, p.last_name, p.patient_id,
       (
           SELECT medication
           FROM medical_records.Prescription pr
           WHERE pr.appointment_id = (
               SELECT appointment_id
               FROM medical_records.Appointment a
               WHERE a.patient_id = p.patient_id
               ORDER BY date_and_time DESC
               LIMIT 1
           )
           ORDER BY valid_from DESC
           LIMIT 1
       ) AS last_prescription
FROM medical_records.Patient p;

-- Посчитать среднее число посещений на врача
SELECT doctor_id, AVG(num_appointments) OVER () AS avg_appointments_per_doctor
FROM (
    SELECT doctor_id, COUNT(appointment_id) AS num_appointments
    FROM medical_records.Appointment
    GROUP BY doctor_id
) subquery