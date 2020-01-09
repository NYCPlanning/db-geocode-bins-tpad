DB_CONTAINER_NAME=bins

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM bin_geocode)
                                TO '/home/db-geocode-bins-tpad/output/bin_geocode.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM bin_not_in_tpad)
                                TO '/home/db-geocode-bins-tpad/output/bin_not_in_tpad.csv'
                                DELIMITER ',' CSV HEADER;"
