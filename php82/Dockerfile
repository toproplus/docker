# timeerror/php:8.2.5            =>  PHP_VERSION=8.2.5   FFMPEG_VERSION=7.1.1 MONGODB_VERSION=1.15
# timeerror/php:8.2.29           =>  PHP_VERSION=8.2.29  FFMPEG_VERSION=7.1.1 MONGODB_VERSION=2.1

ARG PHP_VERSION=8.2.5

FROM php:${PHP_VERSION}-fpm-alpine

ARG FFMPEG_VERSION=7.1.1
ARG MONGODB_VERSION=1.15

RUN apk add --no-cache build-base bash curl openssl nasm x264-dev x265-dev libvpx-dev fdk-aac-dev c-ares autoconf unzip \ 
 && rm -rf /var/cache/apk/*

RUN wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && tar -zxvf yasm-1.3.0.tar.gz \
 && rm yasm-1.3.0.tar.gz && cd yasm-1.3.0 && ./configure && make && make install && cd ../ && rm -rf yasm-1.3.0

RUN wget https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && tar -zxvf ffmpeg-${FFMPEG_VERSION}.tar.gz \
 && rm ffmpeg-${FFMPEG_VERSION}.tar.gz \
 && cd ffmpeg-${FFMPEG_VERSION} && ./configure --enable-gpl --enable-libx264 --enable-libx265 --enable-libvpx --enable-libfdk-aac --enable-nonfree \
 && make -j2 V=1 && make install && cd ../ && rm -rf ffmpeg-${FFMPEG_VERSION}

#RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions gd imagick pdo_mysql pdo_pgsql amqp bcmath opcache zip redis sockets event decimal soap pcre pcntl posix

# 只安装，不启用，通过入口脚本动态启用

# 容易安装失败的先安装
RUN IPE_DONT_ENABLE=1 install-php-extensions blackfire  

RUN IPE_DONT_ENABLE=1 install-php-extensions xdebug memcached apcu ssh2 protobuf \
    ast bitset uuid igbinary brotli bz2 calendar csv dba ds enchant ev excimer \
    exif ffi grpc maxminddb xsl gettext intl snmp msgpack snappy inotify \
    rdkafka tideways ioncube_loader newrelic uopz swoole-^6.0@stable


RUN IPE_DONT_ENABLE=1 install-php-extensions mongodb-^${MONGODB_VERSION}@stable

RUN chmod -R 755 /usr/local/lib/php/extensions/no-debug-non-zts-*

RUN echo "export TERM=xterm" >> /root/.bashrc \
    && mv /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf.backup \
    && mkdir /php \
    && ln -s /php/php.ini /usr/local/etc/php/php.ini \
    && ln -s /php/php-fpm.conf /usr/local/etc/php-fpm.conf

RUN apk del build-base     

WORKDIR /www

# 入口脚本
COPY conf/entrypoint.sh /php/entrypoint.sh
RUN chmod 755 /php/entrypoint.sh
ENTRYPOINT ["/php/entrypoint.sh"]

CMD php-fpm
