CREATE OR REPLACE FUNCTION bookstore.get_current_coordinate()
 RETURNS TABLE(latitude_from text, longitude_from text, latitude_to text, longitude_to text, id bigint, taxi_class_name_eng text)
 LANGUAGE sql
AS $function$
	select trf.latitude_from -- Широта
		  ,trf.longitude_from -- долгота
		  ,trf.latitude_to
		  ,trf.longitude_to
		  ,trf.id 
		  ,tc.taxi_class_name_eng 
		  --,trf.time_from 
		  --,trf.time_to 
	from taxi_roads_facts trf
	join taxi_class tc on tc.id = trf.taxi_class_id 
	where trf.price is null
	  and trf.time_from >= date_trunc('minute', now()) - interval '15 minute'
	  and trf.time_to <= date_trunc('minute', now()) + interval '15 minute'
	order by trf.time_from
	limit 10;
	
$function$
;
