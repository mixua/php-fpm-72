# php-fpm+php7.2

Simple config for php7.2 and php-fpm based on Ubuntu.
You can use this image with Nginx or/and Apache on localhost

# For example:
docker run -h mysitename.org -p 9000:9000 --name mycontainer --restart always -v /var/www/html:/var/www/html -P -d alexmedved/cloud
And yes you can use Dockerfile for you own images.

# [PHP Modules]
bcmath, bz2, calendar, Core, ctype, curl, date, dom, exif, fileinfo, filter, ftp,
gd, gettext, hash, iconv, json, libxml, mbstring, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_mysql,
Phar, posix, readline, Reflection, session, shmop, SimpleXML, soap, sockets, sodium, SPL, standard,
sysvmsg, sysvsem, sysvshm, tidy, tokenizer, wddx, xml, xmlreader, xmlwriter, xsl, Zend OPcache, zip, zlib, php-redis
