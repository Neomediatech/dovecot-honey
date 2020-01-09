#!/bin/bash

set -e

DEBUG="${DEBUG:-}"
[ "$DEBUG" == 'true' ] && set -x

LOGDIR="/data/logs"
[ ! -d "${LOGDIR}" ] && mkdir -p $LOGDIR
LOGFILE="${LOGDIR}/dovecot.log"
if [ ! -f $LOGFILE ]; then
  touch $LOGFILE
fi
chmod 666 $LOGFILE
HOMEDIRS="${HOMEDIRS:-/data/home}"
[ ! -d "${HOMEDIRS}" ] && mkdir -p $HOMEDIRS
chown 5000:5000 $HOMEDIRS
chmod 775 $HOMEDIRS

if [ ! -f /etc/dovecot/fullchain.pem ]; then
  cp /etc/ssl/dovecot/server.pem /etc/dovecot/fullchain.pem
  cp /etc/ssl/dovecot/server.key /etc/dovecot/privkey.pem 
fi

if [ -f /servername_cert ]; then
  servername_cert="$(grep "^[[:alnum:]]" /servername_cert|head -n1|tr -d " ")"
  if [ -n "$servername_cert" ]; then
    sed -i "s/^ssl_cert.*$/ssl_cert = <\/data\/certs\/live\/$servername_cert\/fullchain\.pem/" /etc/dovecot/dovecot.conf
    sed -i "s/^ssl_key.*$/ssl_key = <\/data\/certs\/live\/$servername_cert\/privkey.pem/" /etc/dovecot/dovecot.conf
  fi
fi

COMMONDIR="${COMMONDIR:-/data/common}"
[ ! -d "${COMMONDIR}" ] && mkdir -p $COMMONDIR
if [ ! -f "${COMMONDIR}/dh-dovecot.pem" ]; then
  openssl dhparam 2048 > "${COMMONDIR}/dh-dovecot.pem"
fi

exec tail -f "$LOGFILE" &
exec "$@"
