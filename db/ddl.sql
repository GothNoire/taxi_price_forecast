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
	coordinate_from geometry(point, 4326) NULL,
	coordinate_to geometry(point, 4326) NULL,
	longitude_to text NULL,
	latitude_to text NULL,
	is_rainy int4 NULL,
	is_snowy int4 NULL,
	wind_speed float8 NULL,
	clouds_percent float8 NULL,
	current_temperature float8 NULL,
	city_district_from text NULL,
	city_district_to text NULL,
	CONSTRAINT chk_is_rainy CHECK ((is_rainy = ANY (ARRAY[0, 1]))),
	CONSTRAINT chk_is_snowy CHECK ((is_snowy = ANY (ARRAY[0, 1]))),
	CONSTRAINT taxi_roads_facts_pk PRIMARY KEY (id)
);



ALTER TABLE taxi_roads_facts ADD CONSTRAINT currency_taxi_roads_facts_fk FOREIGN KEY (currency_id) REFERENCES currency(id);
ALTER TABLE taxi_roads_facts ADD CONSTRAINT taxi_class_taxi_roads_facts_fk FOREIGN KEY (taxi_class_id) REFERENCES taxi_class(id);


create table aggregate_taxi_roads (id int4 NOT NULL GENERATED ALWAYS AS IDENTITY
								   ,is_snowy integer
								   ,is_rainy integer
								   ,distance_travel float
								   ,time_from timestamp
								   ,time_to timestamp
								   ,avg_price float
								   ,median_price float
								   ,waiting_time float
								   ,road_traffic float
								   ,travel_time float
								   ,city_district_from text
								   ,city_district_to text
								   ,CONSTRAINT aggregate_taxi_roads_pk PRIMARY KEY (id)
								   );
								   