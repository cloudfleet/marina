# marina

An open source alternative to Docker Hub supporting ARM architectures. Extending
the [Docker Registry](https://github.com/docker/docker-registry) with a simple
web UI for automatically building new images from GitHub repositories.

## Installation

### Basic server setup

Set up your ARM-based server with a Debian Jessie image so that it can accessed
via SSH through *some_ip*. Move into the *scripts/ansible* directory and edit
*hosts* to:

    [marina]
    marina ansible_ssh_port=22 ansible_ssh_user=root ansible_ssh_host=some_ip

Copy over your public SSH key to the server (if `ssh-copy-id` is not available,
  copy the file over manually).

    ssh-copy-id root@some_ip

### Keeping things secure

Create an SSL certificate. If you want to self-sign it do:

    openssl req -x509 -newkey rsa:4086 -keyout key.pem -out cert.pem \
    -days 3650 -nodes

Create the user accounts:

    htpasswd -c docker-registry.htpasswd user1 # for the first user
    htpasswd docker-registry.htpasswd userN # for every subsequent user

Copy these files as `key.pem`, `cert.pem` and `htpasswd-registry.pem` to
*scripts/ansible/security/*.

### Ansible scripts for deploying

[Install Ansible](http://docs.ansible.com/intro_installation.html). Test that
the machine is indeed accessible:

    ansible -i ./hosts -m ping marina

Great, now you can run the playbook with:

    ansible-playbook marina.yml

Later, to just rebuild the images run:

    ansible-playbook marina.yml -t build

To skip the building do:

    ansible-playbook marina.yml --skip-tags=build

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
- or using containers:
  https://registry.hub.docker.com/u/marvambass/nginx-registry-proxy/
- even more tutorials:
  http://allthelayers.com/2014/11/setting-up-a-private-docker-registry-over-https/

- build images on external media (usb)
- add scripts to clean old/deleted containers/images
