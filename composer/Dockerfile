FROM timeerror/php:7.4.29

WORKDIR /www

ENV COMPOSER_HOME /tmp

RUN echo "extension=swoole.so" > /usr/local/etc/php/conf.d/php-ext-swoole.ini
#RUN curl -sS https://getcomposer.org/installer | php
#RUN wget https://github.com/composer/composer/releases/download/1.10.16/composer.phar
RUN wget https://getcomposer.org/download/2.3.5/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN composer config -gl | grep repositories.packagist.org.url
RUN composer

ENTRYPOINT [""]

CMD "/bin/bash"
