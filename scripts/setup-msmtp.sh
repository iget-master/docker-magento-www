#!/bin/bash
#
# You can setup MSMTP by setting the following environment variables
#
# MSMTP_HOST     - The SMTP server hostname (required)
# MSMTP_PORT     - The SMTP server port number (default: 587)
# MSMTP_TLS      - Enables the TLS encryption - valid values: on,off (default: on)
# MSMTP_AUTH     - Enables SMTP authentication - valid values: on,off (default: on)
# MSMTP_USER     - The authentication username (required)
# MSMTP_PASSWORD - The authentication password (required)
# MSMTP_FROM     - The address to receive bounces (required)

if [[ $MSMTP_FROM ]] && [[ $MSMTP_HOST ]] && [[ $MSMTP_USER ]] && [[ $MSMTP_PASSWORD ]]; then

# set reasonable defaults

MSMTP_TLS=${MSMTP_TLS:-on}
MSMTP_AUTH=${MSMTP_AUTH:-on}
MSMTP_PORT=${MSMTP_PORT:-587}

cat << EOF > /etc/msmtprc
# Set defaults.
defaults

# Enable or disable TLS/SSL encryption.
tls $MSMTP_TLS
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

# Set up a default account's settings.
account default
host $MSMTP_HOST
port $MSMTP_PORT
auth $MSMTP_AUTH
user $MSMTP_USER
password $MSMTP_PASSWORD
from $MSMTP_FROM
syslog LOG_MAIL
EOF

fi
