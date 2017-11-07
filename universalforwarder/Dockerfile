FROM splunk/universalforwarder:7.0.0

ENV SPLUNK_BACKUP_APP ${SPLUNK_HOME}/etc/apps

# Enable File Input Monitor for docker host
COPY ta-dockerlogs_fileinput ${SPLUNK_BACKUP_APP}/ta-dockerlogs_fileinput

# Enable Docker Stats Collection
#https://docs.docker.com/engine/installation/linux/docker-ce/binaries/#install-daemon-and-client-binaries-on-linux
ENV DOCKER_VERSION 17.06.2
COPY ta-dockerstats ${SPLUNK_BACKUP_APP}/ta-dockerstats
RUN chmod +x ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/*.sh
RUN apt-get update \
    && apt-get install -y wget jq \
    && apt-get install -y dnsutils \
    && wget -qO ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/docker-${DOCKER_VERSION}-ce.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}-ce.tgz \
    && mkdir ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/tmp \
    && tar xzvf ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/docker-${DOCKER_VERSION}-ce.tgz -C ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/tmp \
    && rm -rf ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/docker-${DOCKER_VERSION}-ce.tgz \
    && mv ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/tmp/docker/* ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin \
    && chmod +x ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/docker \
    && apt-get purge -y --auto-remove wget \
    && rm -rf /var/lib/apt/lists/* 

# change file ownership to splunk to collect docker perf stats and docker meta data
RUN chown splunk:splunk ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/*.sh
RUN chown splunk:splunk ${SPLUNK_BACKUP_APP}/ta-dockerstats/bin/docker
