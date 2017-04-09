#Resin.io produces base ARM images for raspberry pi. This one adds QEMU support in order to support cross-building (for DockerHub to build ARM projects)
FROM resin/armv7hf-debian-qemu:latest

RUN [ "cross-build-start" ]

MAINTAINER Nick McCarthy

#Volumes will be added via docker run command
#VOLUME ["/config"]
RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y curl wget && \

RUN echo 'deb http://deb.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
        echo '#!/bin/sh'; \
        echo 'set -e'; \
        echo; \
        echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
    } > /usr/local/bin/docker-java-home \
    && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-i386/jre

ENV JAVA_VERSION 8u121
ENV JAVA_DEBIAN_VERSION 8u121-b13-1~bpo8+1

ENV CA_CERTIFICATES_JAVA_VERSION 20161107~bpo8+1

RUN set -x \
    && apt-get update \
    && apt-get install -y -t jessie-backports \
        openjdk-8-jre-headless="$JAVA_DEBIAN_VERSION" \
    ca-certificates-java=$CA_CERTIFICATES_JAVA_VERSION && rm -rf /var/lib/apt/lists/* \
    && [ "$JAVA_HOME" = "$(docker-java-home)" ]

RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

    
RUN mkdir -p /root/habridge/ && \
    cd /root/habridge && \
    VERSION="$(curl -sX GET https://api.github.com/repos/bwssytems/ha-bridge/releases/latest | grep 'tag_name' | cut -d\" -f4)" && \
    wget https://github.com/bwssytems/ha-bridge/releases/download/v"$VERSION"/ha-bridge-"$VERSION".jar    
    mv ha-bridge-"$VERSION".jar ha-bridge.jar

CMD [ "java -jar -Dserver.port=80 ha-bridge.jar 2>&1 | tee /root/habridge/ha-bridge.log"

RUN [ "cross-build-end" ]
