#!/bin/bash

# run as:
# ./scripts/build_docker_images.sh \
#    scripts/docker_images.txt
#    [/build/location]

#TODO: https://github.com/docker-library/node.git /0.10/slim

docker_images_file=$1
build_location=${2:-/tmp/docker_images}

function fetch_code(){
    echo " - fetching code"
    repo_url=$1
    repo_dir=$2
    branch=$3
    if [ -d $repo_dir ]; then
        # if true this block of code will execute
        echo "folder exists, pulling changes on branch $branch"
        (cd $repo_dir; git fetch --all; git checkout -- .; \
         git checkout $branch; git reset --hard origin/$branch)
    else
        echo "cloning $line"
        git clone --depth=1 --branch $branch $repo_url $repo_dir
    fi
}

function patch_dockerfile(){
    echo " - patching Dockerfile"
    sed -i 's/FROM\ ubuntu:14.04/FROM\ hominidae\/armhf-ubuntu/g' Dockerfile
    sed -i 's/FROM\ buildpack-deps/FROM\ mazzolino\/armhf-debian/g' Dockerfile
    sed -i 's/FROM\ debian/FROM\ mazzolino\/armhf-debian/g' Dockerfile
    sed -i 's/FROM\ node:slim/FROM\ library\/node-armhf/g' Dockerfile
    sed -i 's/FROM\ nginx/FROM\ library\/nginx-armhf/g' Dockerfile
}

function tag_image(){
    current_name=$1
    new_name=$2
    docker tag -f $current_name $new_name >/dev/null 2>&1
}

function tag_images(){
    echo " - tagging images"
    # provide additional tags that are necessary
    tag_image library/node-armhf node
    tag_image library/nginx-armhf nginx
    tag_image mazzolino/armhf-debian debian
    tag_image mazzolino/armhf-debian debian:wheezy # for nginx
    tag_image hominidae/armhf-ubuntu ubuntu
    tag_image library/registry registry
}

function build_image(){
    repo_url=$1
    image_name=$2
    branch=$3
    dockerfile_path=$4
    repo_dir=$build_location/$image_name
    echo "Building image: $image_name" && echo "------------------------------"
    echo " - fetching $repo_url ($branch) to $repo_dir"
    fetch_code $repo_url $repo_dir $branch
    cd $repo_dir/$dockerfile_path
    patch_dockerfile
    tag_images
    image_name=`echo "$image_name" | sed 's/./\L&/g'` # lowercase
    echo " - building Docker image as $image_name"
    docker build -t $image_name .
    echo " - image built"
}

function clean_up(){
    rm -rf $build_location
}

function build_all_images(){
    echo "Building all images" && echo "===================" && echo " - from $docker_images_file in $build_location"
    while read line; do
        build_image $line
    done < $docker_images_file

    #clean_up
}

build_all_images

(cd `dirname $0` && ./clean_docker_none_images.sh)
