# iget/magento-www

This docker image is the base for any Magento 2 development on IGET.

It's based on *Ubuntu 16.04 (Xenial Xerus)* and contains the following stack:

* Nginx
* PHP 7.1

It does not include any database or cache driver, so you must use together with
another docker images. We suggest using `docker-compose` to setup your environment. (See docs/sample-docker-compose.yml)

# Usage

You must install (or put a volume) your Magento over `/var/www`.

The `nginx` is configured to import `/var/www/nginx.conf` configuration. 
You will need to rename `nginx.conf.sample` to `nginx.conf`.

NGINX will listen to port 80 as default. 