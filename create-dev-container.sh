docker container rm dev-container
docker image rm dev-image
docker build -t dev-image .
docker run --detach-keys="ctrl-@" -it --name dev-container dev-image
