#https://docs.docker.com/engine/reference/builder/
FROM splunk/splunk:6.5.0

ENV SPLUNK_BACKUP_APP ${SPLUNK_BACKUP_DEFAULT_ETC}/etc/apps

# Enable HEC with default token - 00000000-0000-0000-0000-000000000000
RUN rm -rf ${SPLUNK_BACKUP_APP}/splunk_httpinput
COPY /splunk_httpinput ${SPLUNK_BACKUP_APP}/splunk_httpinput

COPY /app-docker ${SPLUNK_BACKUP_APP}/app-docker
COPY /ta-dockerlogs_fileinput ${SPLUNK_BACKUP_APP}/ta-dockerlogs_fileinput

# Enable Docker Stats Collection
ENV DOCKER_VERSION 1.9.0
COPY /ta-dockerstats ${SPLUNK_BACKUP_APP}/ta-dockerstats
RUN chmod +x ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/*.sh
RUN apt-get update \
    && apt-get install -y wget jq \
    && wget -qO ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/docker https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION} \
    && chmod +x ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/docker \
    && apt-get purge -y --auto-remove wget \
    && rm -rf /var/lib/apt/lists/*
    
# Enable UCP Monitoring 
COPY /ta-ucplogs-sysloginput ${SPLUNK_BACKUP_APP}/ta-ucplogs-sysloginput
