DROP TABLE IF EXISTS bin_geocode_tpad_errors;
SELECT geo_bbl, geo_bin, geo_tpad_new_bin, geo_tpad_new_bin_status,
get_tpad_dm_bin_status, geo_tpad_conflict_flag, geo_tpad_bin_status,
geo_return_code, geo_message, geo_reason_code
INTO bin_geocode_tpad_errors
FROM bin_geocode
WHERE geo_return_code NOT IN ('00', '01')
AND (geo_bin IN ('1000000', '2000000', '3000000', '4000000', '5000000')
OR geo_tpad_new_bin > ' '
OR geo_tpad_new_bin_status > ' '
OR get_tpad_dm_bin_status > ' '
OR geo_tpad_conflict_flag > ' '
OR geo_tpad_bin_status > ' ')
