FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y maven git && rm -rf /var/lib/apt/lists/*

ARG user=kite
ARG group=kite
ARG uid=1000
ARG gid=1000

ENV HOME /var/kite_home

# Jenkins is run with user `kite`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /var/kite_home

WORKDIR $HOME
COPY ./KITE KITE
ENV KITE_HOME=$HOME/KITE
WORKDIR $KITE_HOME
ENV PATH=$PATH:$KITE_HOME/scripts/linux/path:$KITE_HOME/third_party/allure-2.10.0/bin
RUN chmod +x scripts/linux/path/*
RUN chmod +x scripts/linux/*.sh
RUN chmod +x $KITE_HOME/third_party/allure-2.10.0/bin/allure
RUN chown -R kite:kite $HOME/KITE

USER ${user}

