DB_CONTAINER_NAME=bins

docker run -it --rm\
            --network=host\
            -v `pwd`:/home/db-geocode-bins-tpad\
            -w /home/db-geocode-bins-tpad\
            --env-file .env\
            sptkl/docker-geosupport:19d bash -c "pip3 install -r python/requirements.txt; python3 python/geocoding.py"

docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/building_footprints_geocoded_tpad.sql
