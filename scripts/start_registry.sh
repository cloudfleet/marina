#/bin/bash

# the --preload option is necessary due to:
# https://github.com/docker/docker-registry/issues/892
docker run -p 5000:5000 -e GUNICORN_OPTS=["--preload"] registry
