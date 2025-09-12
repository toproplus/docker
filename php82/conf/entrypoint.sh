#!/bin/bash
set -e

# 已安装，且默认启用的扩展：
# gd imagick pdo_mysql pdo_pgsql amqp bcmath opcache zip redis sockets event decimal soap pcre pcntl posix

# 已安装，但未启用的扩展
# apcu mongodb swoole ffi ev igbinary xdebug memcached ast bitset ssh2 protobuf uuid blackfire 
# brotli bz2 calendar csv dba ds enchant excimer exif grpc maxminddb xsl gettext intl snmp msgpack 
# snappy inotify rdkafka tideways ioncube_loader newrelic uopz
# 动态启用扩展
# 获取环境变量 ENABLE_EXT，格式为逗号分隔的扩展名
# 若没设置 ENABLE_EXT 环境变量，则使用默认值
ENABLE_EXT="${ENABLE_EXT:-apcu,mongodb,swoole}"
# 打印扩展日志
ENABLE_LOG="${ENABLE_LOG:-1}"
# PHP 扩展配置目录
PHP_CONF_DIR="/usr/local/etc/php/conf.d"

# 初始化：修复部分扩展的配置文件命名格式不统一的问题
init_php_extension() {
    local newrelic="${PHP_CONF_DIR}/newrelic.ini"
    if [ -f "$newrelic" ]; then
        # 默认不启用
        mv "$newrelic" "${PHP_CONF_DIR}/docker-php-ext-newrelic.ini-disabled"
    fi
    local memcached="${PHP_CONF_DIR}/xx-php-ext-memcached.ini-disabled"
    if [ -f "$memcached" ]; then
        mv "$memcached" "${PHP_CONF_DIR}/docker-php-ext-memcached.ini-disabled"
    fi
}
init_php_extension

# 启用指定扩展
enable_php_extension() {
    local ext="$1"
    local src="${PHP_CONF_DIR}/docker-php-ext-${ext}.ini-disabled"
    local dst="${PHP_CONF_DIR}/docker-php-ext-${ext}.ini"

    if [ -f "$dst" ]; then
        log "PHP extension $ext is already enabled."
    elif [ -f "$src" ]; then
        log "Enabling PHP extension: $ext"
        mv "$src" "$dst"
    else
        log "Warning: PHP extension $ext is not found (neither disabled nor enabled)."
    fi
}

# 打印日志
log() {
  if [ "$ENABLE_LOG" -eq 1 ]; then
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] $*"
  fi
}


# 如果 ENABLE_EXT 不为空，则启用对应扩展
if [ -n "$ENABLE_EXT" ]; then
    log "ENABLE_EXT=$ENABLE_EXT"

    # 使用 POSIX 兼容方式分割逗号字符串
    IFS=','; set -f
    for ext in $ENABLE_EXT; do
        ext=$(echo "$ext" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')  # trim 空格
        if [ -n "$ext" ]; then
            enable_php_extension "$ext"
        fi
    done
    set +f; unset IFS
else
    log "No extensions to enable (ENABLE_EXT is empty)."
fi

log "started"

# 执行传入的命令
exec "$@"