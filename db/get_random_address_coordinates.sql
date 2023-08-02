create or replace function get_random_address_coordinates()
returns table (lon_from text, lat_from text, lon_to text, lat_to text)
language plpgsql
as $get_random_address_coordinates$
declare 
lat_from text;
lon_from text;
coordinate_from text;
coordinate_to text;
lat_to text;
lon_to text;
begin 
	coordinate_from := get_random_coordinate_for_empty_schedule();
	lon_from := get_longitude (coordinate_from);
	lat_from := get_latitude (coordinate_from);
    
	coordinate_to := get_random_coordinate_for_empty_schedule();
	lon_to := get_longitude (coordinate_to);
	lat_to := get_latitude (coordinate_to);
    
return query
	select lon_from, lat_from, lon_to, lat_to;
end;
$get_random_address_coordinates$;