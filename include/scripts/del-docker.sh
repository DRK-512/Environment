#!/bin/sh
ERR="\e[31m"
EC="\e[0m"

# Delete all docker data with all flag
if [ ! -z ${1} ]; then
  if [ ${1} = "-a" ] || [ ${1} = "--all" ]; then
    echo "Removing all docker data"
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    docker rmi $(docker images -aq)
    docker system prune
    exit 0
  fi
fi

# Get the ID of the most recently created container
CONTAINER_ID=$(docker ps -a -q | tail -n 1)
IMAGE_ID=$(docker images -a -q | tail -n 1)
# Check if any containers exist
if [ -z ${CONTAINER_ID} ]; then
    echo "${ERR}ERROR: No Docker containers found${EC}"
    exit 0
fi

# Stop the container if it's running
if docker inspect -f '{{.State.Running}}' ${CONTAINER_ID} | grep -q "true"; then
    echo "Stopping container: $CONTAINER_ID"
    docker stop "$CONTAINER_ID"
fi

# Remove the container
echo "Removing container: $CONTAINER_ID"
docker rm ${CONTAINER_ID}

# Get the image ID of the container
IMAGE_ID=$(docker inspect -f '{{.Image}}' ${CONTAINER_ID})

# Remove the image
echo "Removing image: ${IMAGE_ID}"
docker rmi ${IMAGE_ID}

echo "Most recent Docker container and image deleted successfully."

exit 0
