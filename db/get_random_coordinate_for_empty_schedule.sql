create or replace function get_random_coordinate_for_empty_schedule ()
returns table (lat text, lon text)
language sql
as $get_random_coordinate_for_empty_schedule$
  select get_latitude (st_astext(ST_Transform(way, 4326))) lat
        ,get_longitude (st_astext(ST_Transform(way, 4326))) lon
  from planet_osm_point pop 
  where pop."name" is not null
    and round (cast (get_latitude (st_astext(ST_Transform(way, 4326))) as numeric),5 ) between 53.17976 and 53.28380
    and round (cast (get_longitude (st_astext(ST_Transform(way, 4326))) as numeric),5 ) between 50.06998 and 50.29993
  order by random () limit 1;
$get_random_coordinate_for_empty_schedule$;