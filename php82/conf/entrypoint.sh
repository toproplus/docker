#!/bin/bash
set -e

# 已安装，且默认启用的扩展（opcache 由基础镜像自带）：
# gd imagick pdo_mysql mysqli pdo_pgsql pgsql amqp bcmath zip redis sockets
# event ev decimal soap pcntl apcu igbinary
# bz2 exif xsl gettext intl snmp（内置扩展，安装即启用；ffi 已在 Dockerfile 中禁用）

# 已安装，但未启用的扩展（可通过 ENABLE_EXT 动态启用）
# mongodb swoole memcached ssh2 protobuf uuid grpc msgpack rdkafka inotify snappy maxminddb（PECL 扩展）
# ffi（内置扩展，Dockerfile 中已将其 ini 改为 .ini-disabled）
# 示例：ENABLE_EXT=mongodb,swoole（默认只启用 mongodb）
# 动态启用扩展
# 获取环境变量 ENABLE_EXT，格式为逗号分隔的扩展名
# 若没设置 ENABLE_EXT 环境变量，则使用默认值
ENABLE_EXT="${ENABLE_EXT:-mongodb}"
# 打印扩展日志
ENABLE_LOG="${ENABLE_LOG:-1}"
# PHP 扩展配置目录
PHP_CONF_DIR="/usr/local/etc/php/conf.d"

# 初始化：统一 install-php-extensions 生成的非标准 ini 命名
# （例如 memcached 生成的是 xx-php-ext-memcached.ini-disabled）
init_php_extension() {
    local f base name dst
    for f in "${PHP_CONF_DIR}"/*-php-ext-*.ini-disabled; do
        [ -e "$f" ] || continue          # 未匹配到文件时 glob 会原样返回
        base=$(basename "$f")
        name=${base#*-php-ext-}
        name=${name%.ini-disabled}
        dst="${PHP_CONF_DIR}/docker-php-ext-${name}.ini-disabled"
        if [ -f "$dst" ]; then
            continue
        fi
        mv "$f" "$dst"
    done
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