
--  процедура, которая создает новый прием и обновляет диагноз, связанный с этим приемом
CREATE OR REPLACE PROCEDURE medical_records.CreateAppointmentAndUpdateDiagnosis (
    p_patient_id INT,
    p_doctor_id INT,
    p_date_and_time TIMESTAMP,
    p_diagnosis_description VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    appointment_id INT;
BEGIN
    -- Создание нового приема
    INSERT INTO medical_records.Appointment (patient_id, doctor_id, date_and_time)
    VALUES (p_patient_id, p_doctor_id, p_date_and_time)
    RETURNING appointment_id INTO appointment_id;

    -- Обновление диагноза
    UPDATE medical_records.Diagnosis
    SET description = p_diagnosis_description, update_ddtt = CURRENT_TIMESTAMP
    WHERE appointment_id = appointment_id;
END;
$$;



-- Добавление нового пациента в таблицу
CREATE OR REPLACE PROCEDURE medical_records.AddNewPatient (
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_date_of_birth DATE,
    IN p_gender VARCHAR(8),
    IN p_address VARCHAR(255),
    IN p_phone_number VARCHAR(50),
    IN p_email VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Проверка, существует ли пациент с такими же именем и датой рождения
    IF NOT EXISTS (
        SELECT 1 FROM medical_records.Patient
        WHERE first_name = p_first_name
        AND last_name = p_last_name
        AND date_of_birth = p_date_of_birth
    ) THEN
        -- Добавление нового пациента
        INSERT INTO medical_records.Patient (first_name, last_name, date_of_birth, gender, address, phone_number, email)
        VALUES (p_first_name, p_last_name, p_date_of_birth, p_gender, p_address, p_phone_number, p_email);
        RAISE NOTICE 'Новый пациент успешно добавлен.';
    ELSE
        RAISE EXCEPTION 'Пациент с таким именем и датой рождения уже существует.';
    END IF;
END;
$$;




 -- выводит все активные рецепты, выписанные указанному пациенту
CREATE OR REPLACE PROCEDURE medical_records.GetActivePrescriptionsForPatient (
    IN p_patient_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Вывод всех активных рецептов для указанного пациента
    SELECT prescription_ID, medication, dosage, valid_from, valid_to
    FROM medical_records.Prescription
    JOIN medical_records.Appointment ON medical_records.Prescription.appointment_id = medical_records.Appointment.appointment_id
    WHERE medical_records.Appointment.patient_id = p_patient_id
    AND CURRENT_DATE BETWEEN valid_from AND valid_to;
END;
$$;



