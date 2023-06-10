CREATE OR REPLACE PROCEDURE bookstore.add_empty_schedule(IN i_date_from timestamp without time zone, IN i_date_to timestamp without time zone, IN i_interval real, IN i_object_name_from text, IN i_object_name_to text)
 LANGUAGE plpgsql
AS $procedure$
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
		   return;
		end if;
	
	    loop
			INSERT INTO bookstore.taxi_roads_facts (area_id, taxi_class_id, currency_id, time_from, time_to, modified_date,
												  price, waiting_time, distance, trave_time, coordinate_from, coordinate_to)
			VALUES(0, 1, 1, l_date_buf ::timestamp ,l_date_buf + interval '15 minute' ,now(), null, null, null, null, (select ST_Transform(way, 4326)
																														from planet_osm_point pop
																														where pop."name"  ilike '%'||i_object_name_from||'%'
																														limit 1),
					(select ST_Transform(way, 4326) 
					from planet_osm_point pop
					where pop."name" ilike '%' || i_object_name_to || '%'
					 limit 1
					)
				  ) returning id into l_taxi_roads_facts_id;
		    
		    update taxi_roads_facts trf
		    set longitude_from = get_longitude (ST_AsText(trf.coordinate_from))
					,latitude_from = get_latitude (ST_AsText(trf.coordinate_from))
					,latitude_to = get_latitude (ST_AsText(trf.coordinate_to))
					,longitude_to = get_longitude (ST_AsText(trf.coordinate_to))
		    where id = l_taxi_roads_facts_id;
				 
			l_date_buf := l_date_buf + interval '15 minute';
			exit when l_date_buf = l_date_hour_end;
	    end loop;
    end loop;
end; $procedure$
;
