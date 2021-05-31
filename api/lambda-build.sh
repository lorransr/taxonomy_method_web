echo 'Starting build'
docker build -f Dockerfile-build -t lambci_lambda .
docker rm 'lambci_build' -f
docker run --rm -it -d --name lambci_build lambci_lambda bash
docker cp lambci_build:var/task/lambda-docker.zip .