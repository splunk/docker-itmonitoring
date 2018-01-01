#https://docs.docker.com/engine/reference/builder/
FROM splunk/universalforwarder:7.0.0

ENV SPLUNK_BACKUP_APP ${SPLUNK_BACKUP_DEFAULT_ETC}/etc/apps

# install curl vim and jq
RUN apt-get update && apt-get install -y \
    curl \
    vim  \
    jq

# copy ta-k8s-meta 
#MIGHT NEEED ESCAPING ON THE HYPHENS!
COPY ta-k8s-meta ${SPLUNK_BACKUP_APP}/ta-k8s-meta/
