DB_CONTAINER_NAME=bins

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM bin_geocode_tpad)
                                TO '/home/db-geocode-bins-tpad/output/bin_geocode_tpad.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM bin_geocode_tpad_errors)
                                TO '/home/db-geocode-bins-tpad/output/bin_geocode_tpad_errors.csv'
                                DELIMITER ',' CSV HEADER;"
