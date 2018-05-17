#https://docs.docker.com/engine/reference/builder/
FROM splunk/splunk:7.0.3

ENV SPLUNK_BACKUP_APP ${SPLUNK_BACKUP_DEFAULT_ETC}/etc/apps

# Enable HEC with default token - 00000000-0000-0000-0000-000000000000
RUN rm -rf ${SPLUNK_BACKUP_APP}/splunk_httpinput
COPY /splunk_httpinput ${SPLUNK_BACKUP_APP}/splunk_httpinput

COPY /app-docker ${SPLUNK_BACKUP_APP}/app-docker
COPY /ta-dockerlogs_fileinput ${SPLUNK_BACKUP_APP}/ta-dockerlogs_fileinput
    
# Enable UCP Monitoring 
COPY /ta-ucplogs-sysloginput ${SPLUNK_BACKUP_APP}/ta-ucplogs-sysloginput
