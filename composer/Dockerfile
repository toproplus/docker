# timeerror/composer:php7.4.29-ffmpeg4.4
# FROM timeerror/php:7.4.29-ffmpeg4.4

# timeerror/composer:php7.4.29        
# FROM timeerror/php:7.4.29

# timeerror/composer:php7.4.33            
# FROM timeerror/php:7.4.33

# timeerror/composer:php8.2.5             
# FROM timeerror/php:8.2.5

# timeerror/composer:php8.2.29            
# FROM timeerror/php:8.2.29

# timeerror/composer:php8.2.29-stage
# FROM timeerror/php:8.2.29-stage

# timeerror/composer:php8.2.29-stage-mongo1.21
# FROM timeerror/php:8.2.29-stage-mongo1.21

# timeerror/composer:php8.3.23
FROM timeerror/php:8.3.23

WORKDIR /www

# 部分库需要依赖git拉取另外的代码
RUN apk update && apk add --no-cache git && rm -rf /var/cache/apk/*

RUN mkdir -p /tmp/composer && chmod -R 777 /tmp
ENV COMPOSER_HOME /tmp

RUN wget https://getcomposer.org/download/2.5.5/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer


RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN composer config -gl | grep repositories.packagist.org.url


# ENTRYPOINT [""]

CMD "/bin/bash"
