gtar -cvf ./app-docker.tar ./app-docker/
gzip ./app-docker.tar
mv ./app-docker.tar.gz ./app-docker.spl 
