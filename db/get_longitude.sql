CREATE OR REPLACE FUNCTION get_longitude(i_st_point text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$	
begin 
	return substring(i_st_point from 7 for strpos(i_st_point, ' ')-7);
end; $function$
;
