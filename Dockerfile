FROM openjdk:8-jre-alpine3.9
LABEL maintainer="kalaksi@users.noreply.github.com"

ENV CONTEXT_PATH "/"
# A space-separated list, e.g. "-Dairsonic.example1=example -Dserver.example2=example"
ENV JAVA_OPTS ""

ENV AIRSONIC_VERSION 10.3.1
ENV AIRSONIC_UID 163769
ENV AIRSONIC_GID 163769


# TODO: use environment vars with chown (or alternatively use --chmod) when those are implemented in Docker.
# Meanwhile, hardcoding the UID and GID here probably won't be an issue.
ADD --chown=163769:163769 https://github.com/airsonic/airsonic/releases/download/v${AIRSONIC_VERSION}/airsonic.war /opt/
ADD --chown=163769:163769 https://github.com/airsonic/airsonic/releases/download/v${AIRSONIC_VERSION}/airsonic.war.asc /opt/

# Docker will use ownership of mount points for initializing named volumes on the host,
# so they'll have correct owner automatically.
RUN mkdir -p /var/airsonic /media && \
    chown -R ${AIRSONIC_UID}:${AIRSONIC_GID} /var/airsonic

RUN apk add --no-cache \
      ffmpeg \
      flac \
      gnupg \
      lame && \
    # Verify package signature and clean up afterwards
    gpg --keyserver keyserver.ubuntu.com --recv F7E5D48CF5F4061684A626200A3F5E91F8364EDF && \
    (gpg /opt/airsonic.war.asc || exit 1) && \
    rm -r /opt/airsonic.war.asc ~/.gnupg; \
    apk del --no-cache gnupg

EXPOSE 8080
VOLUME /var/airsonic /media
USER ${AIRSONIC_UID}:${AIRSONIC_GID}
ENTRYPOINT set -eu; \
           mkdir -p /var/airsonic/transcode; \
           [ -e /var/airsonic/transcode/ffmpeg ] || ln -s /usr/bin/ffmpeg /var/airsonic/transcode/; \
           [ -e /var/airsonic/transcode/flac ]   || ln -s /usr/bin/flac /var/airsonic/transcode/; \
           [ -e /var/airsonic/transcode/lame ]   || ln -s /usr/bin/lame /var/airsonic/transcode/; \
           exec /usr/bin/java -Dairsonic.home=/var/airsonic -Dserver.contextPath=${CONTEXT_PATH} $JAVA_OPTS -jar /opt/airsonic.war
