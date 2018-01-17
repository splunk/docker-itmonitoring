# Build for running on Mac OsX, using gtar to prevent untarring issues on linux, https://superuser.com/questions/318809/linux-os-x-tar-incompatibility-tarballs-created-on-os-x-give-errors-when-unt
# using GNU tar
gtar -zcvf ./app-k8s.tar ./app-k8s/
mv ./app-k8s.tar ./app-k8s.spl 