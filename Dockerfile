#FROM adoptopenjdk/openjdk11:debian-slim
FROM eclipse-temurin:11

# Configuration variables.
ENV SOFT		confluence
#ENV SOFTSUB		core
ENV OPENJDKV		11
ENV CONF_HOME		/var/atlassian/${SOFT}
ENV CONF_INSTALL	/opt/atassian/${SOFT}
ENV CONF_VERSION	8.0.0

ENV JAVA_CACERTS	$JAVA_HOME/jre/lib/security/cacerts
ENV CERTIFICATE		$CONF_HOME/certificate

ENV SOFT_HOME		${CONF_HOME}
ENV SOFT_INSTALL	${CONF_INSTALL}
ENV SOFT_VERSION	${CONF_VERSION}

# download option
RUN apt-get update && apt-get install -y curl bash && \
	curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh -o /option.sh && \
	chmod 755 /option.sh

# copyright and timezone
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/copyright.sh | bash

# install
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20Atlassian/${SOFT}_install.sh | bash

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
