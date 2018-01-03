#https://docs.docker.com/engine/reference/builder/
FROM splunk/splunk:7.0.0

ENV SPLUNK_BACKUP_APP ${SPLUNK_BACKUP_DEFAULT_ETC}/etc/apps

# Enable container version of the k8s app 

COPY app-k8s ${SPLUNK_BACKUP_APP}/app-k8s
