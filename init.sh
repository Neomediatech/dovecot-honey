#!/bin/sh

set -e

[ "$DEBUG" == 'true' ] && set -x

mkdir -p /var/log/dovecot/ /tmp/dovecot ; touch /var/log/dovecot/dovecot.log
chmod 777 /var/log/dovecot /tmp/dovecot
chmod 666 /var/log/dovecot/dovecot.log

dovecot
tail -f /var/log/dovecot/dovecot.log


