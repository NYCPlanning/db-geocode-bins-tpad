CREATE TABLE bin_geocode_tpad AS
SELECT *
FROM bin_geocode
WHERE (geo_bin IN ('1000000', '2000000', '3000000', '4000000', '5000000')
OR geo_tpad_new_bin > ' '
OR geo_tpad_new_bin_status > ' '
OR get_tpad_dm_bin_status > ' '
OR geo_tpad_conflict_flag > ' '
OR geo_tpad_bin_status > ' ');
