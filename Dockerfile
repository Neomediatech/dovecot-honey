FROM alpine:3.10

ENV DOVECOT_VERSION=2.3.7.2-r0
ENV BUILD_DATE=2019-08-29
ENV ALPINE_VERSION=3.10

ENV TZ=Europe/Rome

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$DOVECOT_VERSION \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/dovecot-honey-docker-alpine \
      org.label-schema.maintainer=Neomediatech

RUN apk update && apk upgrade && apk add --no-cache tzdata && cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    apk add --no-cache tini dovecot dovecot-pop3d bash && \
    rm -rf /usr/local/share/doc /usr/local/share/man && \
    rm -rf /etc/dovecot/* && \
    mkdir -p /var/log/dovecot /var/lib/dovecot && \ 
    chmod 777 /var/log/dovecot
COPY dovecot.conf users dovecot-ssl.cnf /etc/dovecot/
RUN openssl req -new -x509 -nodes -days 3650 -config /etc/dovecot/dovecot-ssl.cnf -out /etc/dovecot/server.pem -keyout /etc/dovecot/server.key && \
    chmod 0600 /etc/dovecot/server.key && openssl dhparam -dsaparam -out /etc/dovecot/dh.pem 2048

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 110 143 993 995

HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=5 CMD doveadm service status 1>/dev/null && echo 'At your service, sir' || exit 1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tini", "--", "dovecot","-F"]
