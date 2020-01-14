CREATE TABLE bin_geocode_tpad AS
SELECT *
FROM bin_geocode
WHERE geo_return_code IN ('22', '23');
--WHERE geo_bin IN ('1000000', '2000000', '3000000', '4000000', '5000000')
--OR geo_message > ' '
--OR geo_message_2 > ' ';
