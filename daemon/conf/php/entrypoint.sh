#!/bin/bash
# 初始化
echo "启动时间: $(date)"

# 已安装，且默认启用的扩展：
# gd imagick pdo_mysql pdo_pgsql amqp bcmath opcache zip redis sockets event decimal soap pcre pcntl posix

# 已安装，但未启用的扩展
# 动态启用，注释则禁用 
# Swoole 项目：建议启用 swoole + FFI + event + ev
docker-php-ext-enable apcu
docker-php-ext-enable mongodb
docker-php-ext-enable swoole
# docker-php-ext-enable ffi
# docker-php-ext-enable ev
# docker-php-ext-enable igbinary
# docker-php-ext-enable xdebug
# docker-php-ext-enable memcached
# docker-php-ext-enable ast
# docker-php-ext-enable bitset
# docker-php-ext-enable ssh2
# docker-php-ext-enable protobuf
# docker-php-ext-enable uuid
# docker-php-ext-enable blackfire
# docker-php-ext-enable brotli
# docker-php-ext-enable bz2
# docker-php-ext-enable calendar
# docker-php-ext-enable csv
# docker-php-ext-enable dba
# docker-php-ext-enable ds
# docker-php-ext-enable enchant
# docker-php-ext-enable excimer
# docker-php-ext-enable exif
# docker-php-ext-enable grpc
# docker-php-ext-enable maxminddb
# docker-php-ext-enable xsl
# docker-php-ext-enable gettext
# docker-php-ext-enable intl 
# docker-php-ext-enable snmp
# docker-php-ext-enable msgpack
# docker-php-ext-enable snappy
# docker-php-ext-enable inotify
# docker-php-ext-enable rdkafka
# docker-php-ext-enable tideways 
# docker-php-ext-enable ioncube_loader
# docker-php-ext-enable newrelic
# docker-php-ext-enable uopz


# 执行传入的命令
exec "$@"