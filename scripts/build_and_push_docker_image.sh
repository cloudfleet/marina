#!/bin/bash

# run as:
# ./scripts/build_and_push_docker_image.sh \
#    <git url> \
#    <git branch> \
#    <Dockerfile path> \
#    <tagname>

#TODO: https://github.com/docker-library/node.git /0.10/slim

echo "Creating working directory ..."
WORK_DIR=$(mktemp -d)
echo " - working directory is $WORK_DIR"

REPO_URL=$1
REPO_BRANCH=$2
DOCKERFILE_PATH=$3
IMAGE_NAME=$4
REGISTRY=$5
REGISTRY_USER=$6
REGISTRY_PASSWORD=$7
REGISTRY_EMAIL=$8

echo "Building image: $IMAGE_NAME" && echo "------------------------------"
echo " - fetching $REPO_URL ($REPO_BRANCH) to $WORK_DIR"
git clone --depth=1 --branch $REPO_BRANCH $REPO_URL $WORK_DIR
cd $WORK_DIR/$DOCKERFILE_PATH

echo " - patching Dockerfile"
sed -i 's/FROM\ (.*)/FROM\ $REGISTRY\/$1/g' Dockerfile

echo " - building Docker image as $image_name"
docker build -t $REGISTRY/$IMAGE_NAME .
echo " - image built"


echo "logging into $registry"
docker login -u $REGISTRY_USER -p $REGISTRY_PASSWORD -e $REGISTRY_EMAIL https://$REGISTRY:443
echo "pushing image"
docker push $REGISTRY/$IMAGE_NAME

rm -rf $WORK_DIR

(cd `dirname $0` && ./clean_docker_none_images.sh)
