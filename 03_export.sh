DB_CONTAINER_NAME=bins

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM bin_geocode)
                                TO '/home/db-geocode-bins-tpad/output/bin_geocode.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM bin_geocode_errors)
                                TO '/home/db-geocode-bins-tpad/output/bin_geocode_errors.csv'
                                DELIMITER ',' CSV HEADER;"
