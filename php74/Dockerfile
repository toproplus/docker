# timeerror/php:7.4.33                => PHP_VERSION=7.4.33 MONGODB_VERSION=1.20
# timeerror/php:7.4.33-mongo1.16.2    => PHP_VERSION=7.4.33 MONGODB_VERSION=1.16

ARG PHP_VERSION=7.4.33
FROM php:${PHP_VERSION}-fpm-alpine

# 兼容旧项目
# 1.20 是 PHP 7.4 官方支持的最新版本，1.16 是旧项目使用的版本
# ARG MONGODB_VERSION=1.20
ARG MONGODB_VERSION=1.16

# 换 apk 国内源（构建机直连 dl-cdn 不稳定，会 Connection refused；国内镜像更稳、更快）
RUN sed -i 's@dl-cdn.alpinelinux.org@mirrors.cloud.tencent.com@g' /etc/apk/repositories

RUN apk add --no-cache build-base bash curl openssl c-ares zip unzip ffmpeg autoconf

# ===== php2shell（CVE-2026-109618 / CVE-2026-109619）修复 =====
# PHP 7.4 已 EOL，官方只提供源码补丁（php-src commit 712e60f9ed，即 conf/ 下这个 patch）；
# 用官方补丁 + 基础镜像自带的同版本源码重编 PHP：版本仍是 7.4.33 → 已装扩展 ABI 不变，无需重编扩展
# 注意：gnu-libiconv-dev 单独安装且不删除（/usr/include 下的 iconv 头文件软链指向它，删掉会变悬空链接）
COPY conf/php-7.4.33-CVE-2026-109618-109619-official-712e60f9ed.patch /tmp/php2shell.patch
RUN set -eux; \
    apk add --no-cache gnu-libiconv-dev; \
    apk add --no-cache --virtual .php-build-deps \
        $PHPIZE_DEPS coreutils bison patch linux-headers \
        libxml2-dev oniguruma-dev libsodium-dev argon2-dev \
        sqlite-dev curl-dev openssl-dev zlib-dev readline-dev; \
    rm -vf /usr/include/iconv.h; \
    ln -sfv /usr/include/gnu-libiconv/*.h /usr/include/; \
    docker-php-source extract; \
    cd /usr/src/php; \
    patch -p1 < /tmp/php2shell.patch; \
    export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS"; \
    eval "$(php -i | sed -n 's/^Configure Command => //p')"; \
    make -j"$(nproc)"; \
    make install; \
    find /usr/local/bin /usr/local/sbin /usr/local/lib -type f -perm '-0111' \
        -exec sh -c 'strip --strip-all "$1" 2>/dev/null || :' _ {} \; ; \
    rm -f /usr/local/etc/php-fpm.conf.default /tmp/php2shell.patch; \
    docker-php-source delete; \
    apk del --no-network .php-build-deps \
        $PHPIZE_DEPS coreutils bison patch linux-headers \
        libxml2-dev oniguruma-dev libsodium-dev argon2-dev sqlite-dev \
        curl-dev openssl-dev zlib-dev readline-dev; \
    ln -sfv /usr/include/gnu-libiconv/*.h /usr/include/; \
    rm -rf /var/cache/apk/* /tmp/*

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# 生产环境不安装 xdebug（需要调试请另建调试镜像，或运行时自行 pecl install xdebug）
# 以下 RUN 中的 bz2/exif/ffi/xsl/gettext/intl/snmp 属 PHP 内置扩展，安装后即启用
# mcrypt 扩展在 PHP 7.4 中已被移除，需要自行安装
RUN install-php-extensions gd imagick pdo_mysql mysqli pdo_pgsql pgsql amqp bcmath zip redis sockets \
    event ev decimal soap pcntl apcu igbinary-^3.2@stable \
    bz2 exif ffi xsl gettext intl snmp opcache mcrypt

# 只安装，不启用，通过入口脚本动态启用（此处均为 PECL 扩展，IPE_DONT_ENABLE 才真正生效）
# 容易安装失败的先安装
RUN IPE_DONT_ENABLE=1 install-php-extensions msgpack \
    memcached-^3.1@stable uuid maxminddb

RUN IPE_DONT_ENABLE=1 install-php-extensions mongodb-^${MONGODB_VERSION}@stable \
    swoole-^4.8@stable ssh2 protobuf rdkafka inotify snappy grpc

# ffi 默认不加载（安全考虑）；需要时启动容器加 ENABLE_EXT=...,ffi 即可启用
RUN mv /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini \
    /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini-disabled

RUN mv /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf.backup \
    && mkdir /php \
    && ln -sf /php/php.ini /usr/local/etc/php/php.ini \
    && ln -sf /php/php-fpm.conf /usr/local/etc/php-fpm.conf \
    && apk del --no-cache build-base autoconf \
    && rm -rf /var/cache/apk/* /tmp/*

ENV TERM=xterm

RUN chmod -R 755 /usr/local/lib/php/extensions/no-debug-non-zts-*

# 构建期依赖与构建缓存已在上面清理（合并层，减少镜像层数）

WORKDIR /www

# 入口脚本
COPY conf/entrypoint.sh /php/entrypoint.sh
RUN chmod 755 /php/entrypoint.sh
ENTRYPOINT ["/php/entrypoint.sh"]

CMD ["php-fpm"]
