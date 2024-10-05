CREATE INDEX idx_appointment_date_time ON medical_records.Appointment (date_and_time);
/*
 Этот индекс ускорит запросы, которые фильтруют или сортируют
 записи по времени приема. Например, запросы на поиск приемов
 по определенному диапазону дат или сортировка приемов по времени.

*/


CREATE INDEX idx_appointment_patient_date_time ON medical_records.Appointment (patient_id, date_and_time);
/*
 Этот индекс может быть полезен для запросов, которые фильтруют приемы
 по конкретному пациенту и времени приема.
 Такой индекс повысит производительность запросов, которые часто фильтруют
 или сортируют записи по пациенту и времени.
*/


CREATE INDEX idx_diagnosis_appointment_id ON medical_records.Diagnosis (appointment_id);
/*
 Этот индекс ускорит запросы, которые выполняют поиск или фильтрацию диагнозов по
 appointment_id. Например, запросы на получение диагнозов для конкретного приема.

*/


CREATE INDEX idx_prescription_appointment_id ON medical_records.Prescription (appointment_id);
/*
 Этот индекс поможет ускорить запросы, которые фильтруют или сортируют назначения
 по appointment_id, такие как запросы на получение назначений для конкретного приема.

*/


CREATE INDEX idx_doctor_doctor_id ON medical_records.Doctor (doctor_id);
/*
  Этот индекс ускорит запросы, которые фильтруют или сортируют записи
  по идентификатору врача. Например, запросы на поиск врачей по их идентификаторам.
*/