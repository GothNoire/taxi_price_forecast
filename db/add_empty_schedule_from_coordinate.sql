CREATE OR REPLACE FUNCTION bookstore.add_empty_schedule_from_coordinate(in i_date_from timestamp without time zone
                                                                       , in i_date_to timestamp without time zone
                                                                       , in i_lon_from numeric
                                                                       , in i_lat_from numeric
                                                                       , in i_lon_to numeric
                                                                       , in i_lat_to numeric
                                                                       , in i_city_district_name_from text
																	   , in i_city_district_name_to text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
declare
l_date_buf timestamp;
l_date_hour_end timestamp;
l_date_from timestamp;
l_taxi_roads_facts_id bigint;
begin
  l_date_from := i_date_from;
  l_date_buf := date_trunc ('hour', l_date_from);
  loop
    l_date_hour_end := date_trunc ('hour', l_date_buf) + interval '1 hour';
  	
  	if l_date_hour_end = date_trunc ('hour', i_date_to) then
  	   return 0;
  	end if;
  
    loop
  	  INSERT INTO taxi_roads_facts (area_id, taxi_class_id, currency_id, time_from, time_to, modified_date,
  											  price, waiting_time, distance, trave_time, coordinate_from, coordinate_to,
  											  longitude_from, latitude_from, longitude_to, latitude_to,city_district_from,city_district_to)
  	  VALUES(0, 1, 1, l_date_buf ::timestamp ,l_date_buf + interval '15 minute' ,now(), null, null, null, null, null,null,
  	  	     i_lon_from, i_lat_from, i_lon_to, i_lat_to, i_city_district_name_from, i_city_district_name_to text
  	        ) returning id into l_taxi_roads_facts_id;
  			 
  	  l_date_buf := l_date_buf + interval '15 minute';
      exit when l_date_buf = l_date_hour_end;
    end loop;
   end loop;
   return l_taxi_roads_facts_id;
end; $function$
;
