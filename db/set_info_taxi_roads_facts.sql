CREATE OR REPLACE FUNCTION bookstore.set_info_taxi_roads_facts(i_id bigint
											, i_price double precision
											, i_waiting_time double precision
											, i_distance double precision
											, i_travel_time double precision
											, i_is_rainy int
											, i_is_snowy int
											, i_current_temp float
											, i_cloud_percent int
											, i_wind_speed float)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
declare 
begin 
	update taxi_roads_facts trf 
	set price = i_price
		,waiting_time = i_waiting_time
		,distance = i_distance
		,trave_time = i_travel_time
		,is_rainy = i_is_rainy
		,is_snowy = i_is_snowy
		,clouds_percent = i_cloud_percent
		,current_temperature = i_current_temp
		,wind_speed = i_wind_speed
	where trf.id = i_id;

	return found;
end;
$function$
;
