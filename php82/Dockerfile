FROM php:8.2.29-fpm-alpine3.21
#FROM php:8.2.5-fpm-alpine3.17

RUN apk add --no-cache build-base bash curl nasm x264-dev x265-dev libvpx-dev fdk-aac-dev c-ares \ 
 && rm -rf /var/cache/apk/*

RUN wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && tar -zxvf yasm-1.3.0.tar.gz \
 && rm yasm-1.3.0.tar.gz && cd yasm-1.3.0 && ./configure && make && make install && cd ../ && rm -rf yasm-1.3.0

RUN wget https://ffmpeg.org/releases/ffmpeg-7.1.1.tar.gz && tar -zxvf ffmpeg-7.1.1.tar.gz \
 && rm ffmpeg-7.1.1.tar.gz \
 && cd ffmpeg-7.1.1 && ./configure --enable-gpl --enable-libx264 --enable-libx265 --enable-libvpx --enable-libfdk-aac --enable-nonfree \
 && make -j2 V=1 && make install && cd ../ && rm -rf ffmpeg-7.1.1

#RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions gd imagick pdo_mysql pdo_pgsql apcu amqp bcmath opcache pcntl zip redis swoole mongodb-^1.15@stable sockets ssh2 event protobuf memcached igbinary decimal uuid xdebug

RUN chmod -R 755 /usr/local/lib/php/extensions/no-debug-non-zts-*

# 默认关闭一些扩展
# RUN cd /usr/local/etc/php/conf.d && mv docker-php-ext-swoole.ini docker-php-ext-swoole.ini.backup

RUN echo "export TERM=xterm" >> /root/.bashrc \
    && mv /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf.backup \
    && mkdir /php \
    && ln -s /php/php.ini /usr/local/etc/php/php.ini \
    && ln -s /php/php-fpm.conf /usr/local/etc/php-fpm.conf

RUN apk del build-base     

WORKDIR /www

CMD php-fpm
