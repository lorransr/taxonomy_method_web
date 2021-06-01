echo 'Starting build'
docker build -f Dockerfile -t flutter-web .
docker rm 'flutter-web-build' -f
docker run --rm -it -d --name flutter-web-build flutter-web bash
docker cp flutter-web-build:app/build/web/flutter-web.zip .