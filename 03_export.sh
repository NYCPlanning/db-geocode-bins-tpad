DB_CONTAINER_NAME=bins

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM building_footprints_geocoded)
                                TO '/home/db-geocode-bins-tpad/output/building_footprints_geocoded.csv'
                                DELIMITER ',' CSV HEADER;"

docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\copy (SELECT * FROM building_footprints_geocoded_tpad)
                                TO '/home/db-geocode-bins-tpad/output/building_footprints_geocoded_tpad.csv'
                                DELIMITER ',' CSV HEADER;"
