#!/bin/bash

# run as:
# ./scripts/push_docker_images.sh \
#    scripts/docker_images.txt
#    username
#    password
#    email
#    registry.marina.io

docker_images_file=$1
username=$2
password=$3
email=$4
registry=$5

function push_image(){
    repo_url=$1
    image_name=$2
    branch=$3
    dockerfile_path=$4
    #image_name=`echo "$image_name" | sed 's/./\L&/g'` # lowercase
    registry_image_name=$registry/$image_name
    echo "tagging $image_name as $registry_image_name"
    docker tag $image_name $registry_image_name
    echo "pushing Docker image $registry_image_name"
    docker push $registry_image_name
}

function registry_login(){
    echo "logging into $registry"
    docker login -u $username -p $password -e $email $registry
}

function push_all_images(){
    echo "pushing all images from $docker_images_file to $registry"
    registry_login
    while read line; do
        push_image $line
    done < $docker_images_file
}

push_all_images
