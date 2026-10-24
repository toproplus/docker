# timeerror/php:8.2.5            =>  PHP_VERSION=8.2.5    MONGODB_VERSION=1.15
# timeerror/php:8.2.29           =>  PHP_VERSION=8.2.29   MONGODB_VERSION=2.1
# timeerror/php:8.2.35           =>  PHP_VERSION=8.2.35   ONGODB_VERSION=1.21

ARG PHP_VERSION=8.2.35

FROM php:${PHP_VERSION}-fpm-alpine

# 兼容旧项目
ARG MONGODB_VERSION=1.21

RUN apk add --no-cache build-base bash curl openssl c-ares unzip nasm x264-dev x265-dev libvpx-dev fdk-aac-dev autoconf yasm ffmpeg \
 && rm -rf /var/cache/apk/*

RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions gd imagick pdo_mysql pdo_pgsql amqp bcmath opcache zip redis sockets event decimal soap pcre pcntl posix

# 只安装，不启用，通过入口脚本动态启用

# 容易安装失败的先安装
RUN IPE_DONT_ENABLE=1 install-php-extensions ev
RUN IPE_DONT_ENABLE=1 install-php-extensions msgpack
RUN IPE_DONT_ENABLE=1 install-php-extensions maxminddb
RUN IPE_DONT_ENABLE=1 install-php-extensions mongodb-^${MONGODB_VERSION}@stable
RUN IPE_DONT_ENABLE=1 install-php-extensions swoole-^6.2@stable

RUN IPE_DONT_ENABLE=1 install-php-extensions xdebug memcached ssh2 protobuf \
    bitset uuid igbinary brotli bz2 calendar csv dba ds enchant excimer \
    exif ffi grpc xsl gettext intl snmp snappy inotify \
    rdkafka ioncube_loader

RUN chmod -R 755 /usr/local/lib/php/extensions/no-debug-non-zts-*

RUN echo "export TERM=xterm" >> /root/.bashrc \
    && mv /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf.backup \
    && mkdir /php \
    && ln -s /php/php.ini /usr/local/etc/php/php.ini \
    && ln -s /php/php-fpm.conf /usr/local/etc/php-fpm.conf

# 删除纯构建时依赖       
RUN apk del --no-cache build-base    

WORKDIR /www

# 入口脚本
COPY conf/entrypoint.sh /php/entrypoint.sh
RUN chmod 755 /php/entrypoint.sh
ENTRYPOINT ["/php/entrypoint.sh"]

CMD php-fpm
