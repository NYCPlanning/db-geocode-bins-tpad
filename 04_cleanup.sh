DB_CONTAINER_NAME=bins

docker kill $DB_CONTAINER_NAME
docker container prune -f;
docker volume prune -f
