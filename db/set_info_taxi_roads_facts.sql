CREATE OR REPLACE FUNCTION bookstore.set_info_taxi_roads_facts(i_id bigint, i_price double precision, i_waiting_time double precision, i_distance double precision, i_travel_time double precision)
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
	where trf.id = i_id;

	return found;
end;
$function$
;
