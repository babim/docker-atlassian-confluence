FROM openjdk:8-alpine

# Configuration variables.
ENV SOFT		confluence
#ENV SOFTSUB		core
ENV OPENJDKV		8
ENV CONF_HOME		/var/atlassian/${SOFT}
ENV CONF_INSTALL	/opt/atlassian/${SOFT}
ENV CONF_VERSION	5.10.8

ENV JAVA_CACERTS	$JAVA_HOME/jre/lib/security/cacerts
ENV CERTIFICATE		$CONF_HOME/certificate

ENV SOFT_HOME		${CONF_HOME}
ENV SOFT_INSTALL	${CONF_INSTALL}
ENV SOFT_VERSION	${CONF_VERSION}

# download option
RUN apk add --no-cache wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# copyright and timezone
RUN wget --no-check-certificate -O - https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/copyright.sh | bash

# install
RUN wget --no-check-certificate -O - https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20Atlassian/${SOFT}_install.sh | bash

# Use the default unprivileged account. This could be considered bad practice
# on systems where multiple processes end up being executed by 'daemon' but
# here we only ever run one process anyway.
USER daemon:daemon

# Expose default HTTP connector port.
EXPOSE 8090 8091 8443

# Set volume mount points for installation and home directory. Changes to the
# home directory needs to be persisted as well as parts of the installation
# directory due to eg. logs.
VOLUME ["${SOFT_HOME}", "${SOFT_INSTALL}/logs"]

# Set the default working directory as the installation directory.
WORKDIR ${SOFT_HOME}

ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Atlassian as a foreground process by default.
CMD ["/opt/atlassian/confluence/bin/start-confluence.sh", "-fg"]
