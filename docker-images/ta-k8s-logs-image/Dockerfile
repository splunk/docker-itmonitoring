#https://docs.docker.com/engine/reference/builder/
FROM splunk/universalforwarder:7.0.0

ENV SPLUNK_BACKUP_APP ${SPLUNK_BACKUP_DEFAULT_ETC}/etc/apps

# copy ta-k8s-logs
#MIGHT NEED ESCAPING HERE FOR THE HYPHENS
COPY ta-k8s-logs ${SPLUNK_BACKUP_APP}/ta-k8s-logs
