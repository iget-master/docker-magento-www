#!/bin/bash

/bin/bash /scripts/setup-msmtp.sh
exec supervisord -n -c /etc/supervisor/supervisord.conf
