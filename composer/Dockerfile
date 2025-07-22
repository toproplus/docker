# timeerror/composer:php7.4.29-ffmpeg4.4
# FROM timeerror/php:7.4.29-ffmpeg4.4

# timeerror/composer:php7.4.29        
# FROM timeerror/php:7.4.29

# timeerror/composer:php7.4.33            
# FROM timeerror/php:7.4.33

# timeerror/composer:php8.2.5             
# FROM timeerror/php:8.2.5

# timeerror/composer:php8.2.29            
FROM timeerror/php:8.2.29

WORKDIR /www

RUN mkdir -p /tmp/composer && chmod -R 777 /tmp
ENV COMPOSER_HOME /tmp

RUN wget https://getcomposer.org/download/2.5.5/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

# 切换用户
# USER www-data
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN composer config -gl | grep repositories.packagist.org.url
# RUN composer
# 切换回root
# USER root

# ENTRYPOINT [""]

CMD "/bin/bash"
