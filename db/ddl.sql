CREATE TABLE currency (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	currency_name text NULL,
	currency_short_name varchar(10) NULL,
	CONSTRAINT currency_pk PRIMARY KEY (id)
);

CREATE TABLE taxi_class (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	taxi_class_name text NULL,
	taxi_class_name_eng text NULL,
	CONSTRAINT taxi_class_pk PRIMARY KEY (id)
);


CREATE TABLE taxi_roads_facts (
	id int8 NOT NULL GENERATED ALWAYS AS IDENTITY,
	area_id int4 NOT NULL,
	taxi_class_id int4 NOT NULL,
	currency_id int4 NOT NULL,
	time_from timestamp NULL,
	time_to timestamp NULL,
	modified_date timestamp NULL,
	latitude_from text NULL,
	longitude_from text NULL,
	price float4 NULL,
	waiting_time text NULL,
	distance float4 NULL,
	trave_time text NULL,
	coordinate_from bookstore.geometry(point, 4326) NULL,
	coordinate_to bookstore.geometry(point, 4326) NULL,
	longitude_to text NULL,
	latitude_to text NULL,
	CONSTRAINT taxi_roads_facts_pk PRIMARY KEY (id)
);


-- taxi_roads_facts foreign keys

ALTER TABLE bookstore.taxi_roads_facts ADD CONSTRAINT currency_taxi_roads_facts_fk FOREIGN KEY (currency_id) REFERENCES bookstore.currency(id);
ALTER TABLE bookstore.taxi_roads_facts ADD CONSTRAINT taxi_class_taxi_roads_facts_fk FOREIGN KEY (taxi_class_id) REFERENCES bookstore.taxi_class(id);