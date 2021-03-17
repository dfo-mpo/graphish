#!/bin/bash

if [ $# -lt 3 ]; then
  echo "Usage: ./push_docker_hub.sh <DOCKER_HUB_REPO> <IMAGE> <TAG>"
  echo "  DOCKER_HUB_REPO: the repo of Docker Hub"
  echo "  IMAGE: Image name (service name in docker-compose.yml)"
  echo "  TAG: Tag version of the image"
  echo "  EXAMPLES:"
  echo "      ./push_docker_hub.sh dfompo nlp 0.2.0"
  exit
fi

cd $2

docker build -t $1/graphish-$2:$3 .
docker push $1/graphish-$2:$3
docker image prune -f

cd ..
