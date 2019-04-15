#!/bin/sh

set -e

[ "$DEBUG" == 'true' ] && set -x

LOGFILE=/var/log/dovecot/dovecot.log
mkdir -p /var/log/dovecot/ /tmp/dovecot
if [ ! -f $LOGFILE ]; then
  touch $LOGFILE
fi
chmod 777 /var/log/dovecot /tmp/dovecot
chmod 666 /var/log/dovecot/dovecot.log

exec tail -f /data/logs/dovecot.log &
exec "$@"
