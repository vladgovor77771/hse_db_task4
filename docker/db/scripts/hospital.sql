CREATE SCHEMA IF NOT EXISTS hospital AUTHORIZATION popov_stepan206;

CREATE TABLE hospital.stations (
    id BIGSERIAL NOT NULL,
    name TEXT NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE hospital.rooms (
    id BIGSERIAL NOT NULL,
    beds_count INT NOT NULL,
    station_id BIGINT NOT NULL,

    PRIMARY KEY (id)
);

ALTER TABLE hospital.rooms 
    ADD FOREIGN KEY (station_id) REFERENCES hospital.stations (id) ON DELETE CASCADE;

CREATE TABLE hospital.doctors (
    id BIGSERIAL NOT NULL,
    name TEXT NOT NULL,
    area TEXT NOT NULL,
    rank INT NOT NULL,
    qualification TEXT NOT NULL,
    station_id BIGINT NOT NULL,

    PRIMARY KEY (id)
);

ALTER TABLE hospital.doctors 
    ADD FOREIGN KEY (station_id) REFERENCES hospital.stations (id) ON DELETE CASCADE;

CREATE TABLE hospital.patients (
    id BIGSERIAL NOT NULL,
    name TEXT NOT NULL,
    desease TEXT NOT NULL,
    doctor_id BIGINT NOT NULL,

    PRIMARY KEY (id)
);

ALTER TABLE hospital.patients 
    ADD FOREIGN KEY (doctor_id) REFERENCES hospital.doctors (id) ON DELETE CASCADE;

CREATE TABLE hospital.patient_admissions (
    id BIGSERIAL NOT NULL,
    room_id BIGINT NOT NULL,
    patient_id BIGINT NOT NULL,

    PRIMARY KEY (id)
);

ALTER TABLE hospital.patient_admissions 
    ADD FOREIGN KEY (room_id) REFERENCES hospital.rooms (id) ON DELETE CASCADE,
    ADD FOREIGN KEY (patient_id) REFERENCES hospital.patients (id) ON DELETE CASCADE;
