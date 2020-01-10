DROP TABLE IF EXISTS bin_geocode_errors;
SELECT geo_bbl, geo_bin, geo_tpad_new_bin, geo_tpad_new_bin_status, geo_return_code, geo_message, geo_reason_code
INTO bin_geocode_errors
FROM bin_geocode
WHERE geo_return_code NOT IN ('00', '01');
