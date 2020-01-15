DROP TABLE IF EXISTS building_footprints_geocoded_tpad;
SELECT geo_bbl, geo_bin, geo_tpad_new_bin, geo_tpad_new_bin_status,
geo_tpad_dm_bin_status, geo_tpad_conflict_flag, geo_tpad_bin_status,
geo_return_code, geo_return_code_2, geo_message, geo_message_2, geo_reason_code
INTO building_footprints_geocoded_tpad
FROM building_footprints_geocoded
WHERE geo_return_code IN ('22', '23')
OR geo_message LIKE '%TPAD%'
OR geo_message_2  LIKE '%TPAD%';
