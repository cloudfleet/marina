#!/bin/bash

# remove all containers and images
#docker stop $(docker ps -qa)
#docker rm $(docker ps -qa)
#docker rmi $(docker images -qa)

# remove all exited containers
docker rm $(docker ps -aq -f status=exited)

# remove <none> images
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
