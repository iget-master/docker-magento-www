#!/bin/bash
TMP=$(mktemp)


echo "* * * * * php /var/www/bin/magento cron:run | grep -v \"Ran jobs by schedule\" >> /var/www/var/log/magento.cron.log" >> ${TMP}
echo "* * * * * php /var/www/update/cron.php >> /var/www/var/log/update.cron.log" >> ${TMP}
echo "* * * * * php /var/www/bin/magento setup:cron:run >> /var/www/var/log/setup.cron.log" >> ${TMP}

echo ${TMP};

cat ${TMP} | crontab -u www-data -

crontab -u www-data -l
