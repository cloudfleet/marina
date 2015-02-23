# marina

An open source alternative to Docker Hub supporting ARM architectures. Extending
the [Docker Registry](https://github.com/docker/docker-registry) with a simple
web UI for automatically building new images from GitHub repositories.

## Pushing to the registry

    docker login http://<REGISTRY-DOMAIN>:5000
    docker tag <image> <REGISTRY-DOMAIN>:5000/<image>
    docker push <REGISTRY-DOMAIN>:5000/<image>

## Pulling from the registry

    docker login http://<REGISTRY-DOMAIN>:5000
    docker pull <REGISTRY-DOMAIN>:5000/<image>

## Build the images

    scripts/build_docker_images.sh scripts/docker_images.txt /root/docker_images

## TODO

- modify the blimp image building scripts to push the built images
  to the registry
- Make sure it uses HTTPS:
  https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-14-04
