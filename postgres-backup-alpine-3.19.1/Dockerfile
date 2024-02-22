FROM alpine:3.19.1

RUN set -eux; \
    apk add --no-cache --update \
    s3cmd=2.3.0-r3 \
    postgresql16-client=16.2-r0

USER postgres
WORKDIR /home/postgres

#entrypoint
COPY --chown=postgres:postgres ./files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT [ "docker-entrypoint" ]