# marina

An open source alternative to Docker Hub supporting ARM architectures. Extending
the [Docker Registry](https://github.com/docker/docker-registry) with a simple
web UI for automatically building new images from GitHub repositories.

## Installation

Set up your ARM-based server with a Debian Jessie image so that it can accessed
via SSH through *some_ip*. Move into the *scripts/ansible* directory and edit
*hosts* to:

    [marina]
    marina ansible_ssh_port=22 ansible_ssh_user=root ansible_ssh_host=some_ip

Copy over your public SSH key to the server (if `ssh-copy-id` is not available,
  copy the file over manually).

    ssh-copy-id root@some_ip

[Install Ansible](http://docs.ansible.com/intro_installation.html). Test that
the machine is indeed accessible:

    ansible -i ./hosts -m ping marina

Great, now you can run the playbook with:

    ansible-playbook marina.yml

Later, to just rebuild the images run:

    ansible-playbook marina.yml -t build

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
