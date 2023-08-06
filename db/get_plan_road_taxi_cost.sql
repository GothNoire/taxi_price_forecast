create or replace function get_plan_road_taxi_cost (i_distance numeric,
												    i_hour int,
												    i_minute int,
												    i_is_rainy int,
												    i_is_snowy int,
												    i_temp numeric,
												    city_district_name_from text,
												    city_district_name_to text
												   )
returns numeric 
language plpgsql
as  
$get_plan_road_taxi_cost$
declare 
l_time_from text;
l_avg_price numeric;
begin 
   l_time_from := i_hour || ' ' || i_minute;
   
   select atr2.avg_price 
   into l_avg_price
   from aggregate_taxi_roads atr2
   where atr2.time_from = (select max (atr.time_from)
   						from aggregate_taxi_roads atr
   						where atr.time_from <= l_time_from
   					   )
     and atr2.is_rainy = coalesce (i_is_rainy, 0)
     and atr2.is_snowy = coalesce (i_is_rainy, 0)
     and distance_travel = round (i_distance/1000)
     and atr2.city_district_from = city_district_name_from
     and atr2.city_district_to = city_district_name_to;
   
   if l_avg_price is null then
      select avg (atr2.avg_price) 
      into l_avg_price
      from aggregate_taxi_roads atr2
      where atr2.time_from = (select max (atr.time_from)
      				   from aggregate_taxi_roads atr
      				   where atr.time_from <= l_time_from
      				   )
        and atr2.is_rainy = coalesce (i_is_rainy, 0)
   	    and atr2.is_snowy = coalesce (i_is_rainy, 0)
   	    and distance_travel = round (i_distance/1000)
   	    and atr2.city_district_from = city_district_name_from;
   end if;
   
   if l_avg_price is null then
      select avg (atr2.avg_price) 
      into l_avg_price
      from aggregate_taxi_roads atr2
      where atr2.time_from = (select max (atr.time_from)
     					      from aggregate_taxi_roads atr
     					      where atr.time_from <= l_time_from
     					      )
        and atr2.is_rainy = coalesce (i_is_rainy, 0)
        and atr2.is_snowy = coalesce (i_is_rainy, 0)
        and distance_travel = round (i_distance/1000);
   end if;
   
   if l_avg_price is null then
      select avg (atr2.avg_price) 
      into l_avg_price
      from aggregate_taxi_roads atr2
      where atr2.time_from = (select max (atr.time_from)
      					   from aggregate_taxi_roads atr
      					   where atr.time_from <= l_time_from
      					   )
        and atr2.is_rainy = coalesce (i_is_rainy, 0)
        and atr2.is_snowy = coalesce (i_is_rainy, 0);
   end if;
   
   l_avg_price := l_avg_price * (i_distance/1000);
   return l_avg_price;
end;
$get_plan_road_taxi_cost$;