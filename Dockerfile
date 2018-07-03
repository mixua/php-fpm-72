FROM ubuntu:16.04
MAINTAINER  alex.medve@gmail.com

RUN \
		apt-get clean && apt-get -y update && apt-get -y upgrade && \
		apt-get install -y locales curl software-properties-common git && \
		locale-gen en_US.UTF-8 && export TERM=xterm && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && \
		apt-get clean && apt-get -y update && apt-get -y upgrade

# Installing the php modules and third-party software
RUN \
		echo postfix postfix/main_mailer_type string "'Local only'" | debconf-set-selections && \
		echo postfix postfix/mynetworks string "127.0.0.0/8" | debconf-set-selections && \
		echo postfix postfix/mailname string mo.favorite.domain.com | debconf-set-selections && \
		apt-get install -y php7.2-bcmath php7.2-bz2 php7.2-calendar php7.2-common php7.2-curl \
                php7.2-ctype php7.2-dom php7.2 php7.2-fpm php7.2-gd php7.2-gettext php7.2-iconv \
                php7.2-json php7.2-mbstring php7.2-mysql  php7.2-mysqli \
                php7.2-mysqlnd php7.2-readline  php7.2-tokenizer \
                php7.2-shmop php7.2-soap php7.2-sysvmsg  php7.2-tidy  php7.2-wddx \
                php7.2-sysvsem php7.2-sysvshm php7.2-xml php7.2-xmlreader php7.2-xmlwriter php7.2-xsl php7.2-zip \
		php7.2-redis supervisor postfix libsasl2-modules sasl2-bin bsd-mailx

# Configuring the php-fpm
RUN \
		sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini && \
		sed -i "s/display_errors = Off/display_errors = On/" /etc/php/7.2/fpm/php.ini && \
		sed -i "s/upload_max_filesize = .*/upload_max_filesize = 10M/" /etc/php/7.2/fpm/php.ini && \
		sed -i "s/post_max_size = .*/post_max_size = 12M/" /etc/php/7.2/fpm/php.ini && \
		sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/" /etc/php/7.2/fpm/php.ini && \
		sed -i "s/cgi.fix_pathinfo=0/cgi.fix_pathinfo=1/" /etc/php/7.2/fpm/php.ini && \
		sed -i "s/;sendmail_path =*/sendmail_path = \/usr\/sbin\/postfix/" /etc/php/7.2/fpm/php.ini && \
		sed -i -e "s/pid =.*/pid = \/var\/run\/php7.2-fpm.pid/" /etc/php/7.2/fpm/php-fpm.conf && \
		sed -i -e "s/error_log =.*/error_log = \/proc\/self\/fd\/2/" /etc/php/7.2/fpm/php-fpm.conf && \
		sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf && \
		sed -i "s/listen = .*/listen = 9000/" /etc/php/7.2/fpm/pool.d/www.conf && \
		sed -i "s/;catch_workers_output = .*/catch_workers_output = yes/" /etc/php/7.2/fpm/pool.d/www.conf

# Installing Composer and make it available in the PATH
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Cleaning up after apt manager
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000

# Copying files that previously prepared for the image
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY aliases /etc/aliases

RUN newaliases

# Define mountable directories.
VOLUME ["/etc/supervisor/conf.d"]

# Define working directory.
WORKDIR /etc/supervisor/conf.d

# Define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
