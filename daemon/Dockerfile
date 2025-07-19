FROM timeerror/php:7.4.29-ffmpeg4.4

RUN apk update && apk add --no-cache supervisor \
   && rm -rf /var/cache/apk/*

RUN wget https://getcomposer.org/download/2.5.5/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN composer config -gl | grep repositories.packagist.org.url

WORKDIR /app
ENTRYPOINT [""]
CMD /usr/bin/supervisord -c /supervisor/supervisord.conf -n
