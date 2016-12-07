FROM rhel7
MAINTAINER Johan Wennerberg <jwennerberg@redhat.com>

ENV PROMETHEUS_VERSION="1.4.1" \
    PROMETHEUS_URL="https://github.com/prometheus/prometheus/releases/download/v1.4.1/prometheus-1.4.1.linux-amd64.tar.gz"

USER root
RUN INSTALL_PKGS="wget bc gettext lsof rsync tar which" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    curl -k -sL -o /tmp/prometheus.tar.gz ${PROMETHEUS_URL} && \
    tar xfz /tmp/prometheus.tar.gz -C /opt && \
    mv /opt/prometheus-${PROMETHEUS_VERISON}* /opt/prometheus && \
    chmod +x /opt/prometheus/prometheus /opt/prometheus/promtool && \
    mkdir /opt/prometheus/{data,config} && \
    mv /opt/prometheus/prometheus.yml /opt/prometheus/config/ && \
    chown -R 1001:0 /opt/prometheus/data && \
    chmod -R g+w /opt/prometheus/data

EXPOSE  9090
VOLUME  /opt/prometheus/data
WORKDIR /opt/prometheus/data

ENTRYPOINT [ "/opt/prometheus/prometheus" ]
CMD        [ "-config.file=/opt/prometheus/config/prometheus.yml", \
             "-storage.local.path=/opt/prometheus/data", \
             "-web.console.libraries=/opt/prometheus/console_libraries", \
             "-web.console.templates=/opt/prometheus/consoles" ]
