#!/bin/bash

# remove all containers and images
#docker stop $(docker ps -qa)
#docker rm $(docker ps -qa)
#docker rmi $(docker images -qa)

# remove all exited containers
if [[ -n $(docker ps -aq -f status=exited) ]]; then
    docker rm $(docker ps -aq -f status=exited)
fi

# remove <none> images
if [[ -n $(docker images -q --filter "dangling=true") ]]; then
    docker rmi -f $(docker images -q --filter "dangling=true")
    # docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
fi
