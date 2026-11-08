
# timeerror/php:8.2.35-mongo1.16.2        =>  PHP_VERSION=8.2.35   MONGODB_VERSION=1.16.2
# timeerror/php:8.2.35                     =>  PHP_VERSION=8.2.35   MONGODB_VERSION=2.5.5

ARG PHP_VERSION=8.2.35

FROM php:${PHP_VERSION}-fpm-alpine

# 兼容旧项目
# ARG MONGODB_VERSION=2.5
ARG MONGODB_VERSION=1.16

RUN apk add --no-cache build-base bash curl openssl c-ares zip unzip ffmpeg autoconf

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN sed -i 's@dl-cdn.alpinelinux.org@mirrors.cloud.tencent.com@g' /etc/apk/repositories

RUN install-php-extensions gd pdo_mysql pdo_pgsql amqp bcmath opcache zip redis sockets \
    event decimal soap pcntl apcu

# 只安装，不启用，通过入口脚本动态启用
# 容易安装失败的先安装
RUN IPE_DONT_ENABLE=1 install-php-extensions msgpack igbinary-^3.2@stable \
    memcached-^3.3@stable uuid exif bz2 ffi

RUN IPE_DONT_ENABLE=1 install-php-extensions mongodb-^${MONGODB_VERSION}@stable \
    swoole-^6.2@stable ssh2 protobuf rdkafka grpc intl snmp

RUN mv /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf.backup \
    && mkdir /php \
    && ln -sf /php/php.ini /usr/local/etc/php/php.ini \
    && ln -sf /php/php-fpm.conf /usr/local/etc/php-fpm.conf

# 删除纯构建时依赖       
RUN apk del --no-cache build-base autoconf && rm -rf /var/cache/apk/* /tmp/*   

ENV TERM=xterm

RUN chmod -R 755 /usr/local/lib/php/extensions/no-debug-non-zts-*

WORKDIR /www

# 入口脚本
COPY conf/entrypoint.sh /php/entrypoint.sh
RUN chmod 755 /php/entrypoint.sh
ENTRYPOINT ["/php/entrypoint.sh"]

CMD php-fpm
