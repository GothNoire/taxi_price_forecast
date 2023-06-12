CREATE OR REPLACE FUNCTION get_latitude(i_st_point text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$	
begin 
	return substring (i_st_point from strpos(i_st_point, ' ') 
			for length (i_st_point)- strpos(i_st_point, ' '));
end; $function$
;
