CREATE SCHEMA IF NOT EXISTS railway AUTHORIZATION popov_stepan206;

CREATE TABLE railway.cities (
    name TEXT NOT NULL,
    region TEXT NOT NULL,

    PRIMARY KEY (name, region)
);

CREATE TABLE railway.stations (
    city_name TEXT NOT NULL,
    city_region TEXT NOT NULL,
    name TEXT NOT NULL,
    tracks INT NOT NULL,

    PRIMARY KEY (name)
);

ALTER TABLE railway.stations 
    ADD FOREIGN KEY (city_name, city_region) REFERENCES railway.cities (name, region) ON DELETE CASCADE;

CREATE TABLE railway.trains (
    number INT NOT NULL,
    length INT NOT NULL,

    PRIMARY KEY (number)
);

CREATE TABLE railway.train_waybills (
    id BIGSERIAL NOT NULL,
    traint_number INT NOT NULL,
    depature_station_name TEXT NOT NULL,
    arrival_station_name TEXT NOT NULL,
    depature TIMESTAMPTZ NOT NULL,
    arrival TIMESTAMPTZ NOT NULL,

    PRIMARY KEY (id)
);

ALTER TABLE railway.train_waybills 
    ADD FOREIGN KEY (depature_station_name) REFERENCES railway.stations (name) ON DELETE CASCADE,
    ADD FOREIGN KEY (arrival_station_name) REFERENCES railway.stations (name) ON DELETE CASCADE;

CREATE TABLE railway.train_passes (
    train_waybill_id BIGINT NOT NULL,
    station_name TEXT NOT NULL,
    depature TIMESTAMPTZ NOT NULL,
    arrival TIMESTAMPTZ NOT NULL,

    PRIMARY KEY (train_waybill_id, station_name)
);

ALTER TABLE railway.train_passes 
    ADD FOREIGN KEY (station_name) REFERENCES railway.stations (name) ON DELETE CASCADE,
    ADD FOREIGN KEY (train_waybill_id) REFERENCES railway.train_waybills (id) ON DELETE CASCADE;
