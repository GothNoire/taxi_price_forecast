create or replace function update_aggregate_data () returns void
language sql 
as $update_aggregate_data$
  insert into aggregate_taxi_roads (is_snowy, is_rainy, distance_travel, time_from, time_to, avg_price, median_price, waiting_time, road_traffic,
  									travel_time, city_district_from, city_district_to)
  select trf.is_snowy
  	      ,trf.is_rainy
		  ,round (trf.distance/1000) distance_by_km
		  ,extract ('hour' from trf.time_from) || ' ' || extract ('minute' from trf.time_from) time
		  ,null
		  ,avg( trf.price / (trf.distance / 1000)) avg_price_km 
		  ,PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY trf.price / (trf.distance / 1000)) median 
		  ,null--,round(cast (trf.waiting_time as float)/60) waiting_time
		  ,null
		  ,null--,round(cast (trf.trave_time as float)/60) 
		  ,trf.city_district_from 
		  ,trf.city_district_to 
		  --,count (*)
	from taxi_roads_facts trf  
	where trf.price is not null 
	  --and trf.time_from between '2023-05-12 20:00:00'::timestamp and '2023-05-12 21:00:00'::timestamp 
	group by round (trf.distance/1000)  
	        ,extract ('hour' from trf.time_from) || ' ' || extract ('minute' from trf.time_from)
	        ,trf.is_rainy 
		  ,trf.is_snowy 
		  ,trf.city_district_from 
		  ,trf.city_district_to 
		 -- ,round(cast (trf.waiting_time as float)/60) 
		  --,round(cast (trf.trave_time as float)/60) 
	order by round (trf.distance/1000)  
			,extract ('hour' from trf.time_from) || ' ' || extract ('minute' from trf.time_from)	
		on conflict (is_snowy, is_rainy, distance_travel, time_from, city_district_from, city_district_to)
		do update set avg_price =  EXCLUDEd.avg_price
					 ,median_price = excluded.median_price;
$update_aggregate_data$;
