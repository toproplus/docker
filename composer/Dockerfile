#FROM timeerror/php:7.4.29-ffmpeg4.4
FROM timeerror/php:7.4.33

WORKDIR /www

ENV COMPOSER_HOME /tmp

#RUN echo "extension=swoole.so" > /usr/local/etc/php/conf.d/php-ext-swoole.ini
#RUN curl -sS https://getcomposer.org/installer | php
#RUN wget https://github.com/composer/composer/releases/download/1.10.16/composer.phar
RUN wget https://getcomposer.org/download/2.5.5/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

# 切换用户
USER www-data
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN composer config -gl | grep repositories.packagist.org.url
RUN composer

# 切换回root
# USER root

ENTRYPOINT [""]

CMD "/bin/bash"
