
# timeerror/php:8.2.35-mongo1.16.2        =>  PHP_VERSION=8.2.35   MONGODB_VERSION=1.16.2
# timeerror/php:8.2.35                     =>  PHP_VERSION=8.2.35   MONGODB_VERSION=2.5.5

ARG PHP_VERSION=8.2.35

FROM php:${PHP_VERSION}-fpm-alpine

# 兼容旧项目
# ARG MONGODB_VERSION=2.5
ARG MONGODB_VERSION=1.16

# 换 apk 国内源（构建机直连 dl-cdn 不稳定，会 Connection refused；国内镜像更稳、更快）
RUN sed -i 's@dl-cdn.alpinelinux.org@mirrors.cloud.tencent.com@g' /etc/apk/repositories

RUN apk add --no-cache build-base bash curl openssl c-ares zip unzip ffmpeg autoconf

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# 生产环境不安装 xdebug（需要调试请另建调试镜像，或运行时自行 pecl install xdebug）
# 内置扩展（opcache 等）基础镜像已自带，不再重复编译；
# 以下 RUN 中的 bz2/exif/ffi/xsl/gettext/intl/snmp 属 PHP 内置扩展，安装后即启用
RUN install-php-extensions gd imagick pdo_mysql mysqli pdo_pgsql pgsql amqp bcmath zip redis sockets \
    event ev decimal soap pcntl apcu igbinary-^3.2@stable \
    bz2 exif ffi xsl gettext intl snmp

# ffi 默认不加载（安全考虑）；需要时启动容器加 ENABLE_EXT=...,ffi 即可启用
RUN mv /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini \
       /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini-disabled

# 只安装，不启用，通过入口脚本动态启用（此处均为 PECL 扩展，IPE_DONT_ENABLE 才真正生效）
# 容易安装失败的先安装
RUN IPE_DONT_ENABLE=1 install-php-extensions msgpack \
    memcached-^3.3@stable uuid maxminddb

RUN IPE_DONT_ENABLE=1 install-php-extensions mongodb-^${MONGODB_VERSION}@stable \
    swoole-^6.2@stable ssh2 protobuf rdkafka inotify snappy grpc

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
