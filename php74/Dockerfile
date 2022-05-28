FROM php:7.4.29-fpm-alpine

RUN apk add --no-cache build-base bash

RUN wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && tar -zxvf yasm-1.3.0.tar.gz \
 && rm yasm-1.3.0.tar.gz && cd yasm-1.3.0 && ./configure && make && make install && cd ../ && rm -rf yasm-1.3.0

RUN wget http://www.ffmpeg.org/releases/ffmpeg-4.4.tar.gz && tar -zxvf ffmpeg-4.4.tar.gz \
 && rm ffmpeg-4.4.tar.gz \
 && cd ffmpeg-4.4 && ./configure --prefix=/usr/local/ffmpeg \
 && make && make install && cd ../ && rm -rf ffmpeg-4.4
RUN touch /etc/profile.d/ffmpeg.sh && echo "export PATH=\$PATH:/usr/local/ffmpeg/bin" >> /etc/profile.d/ffmpeg.sh \
 && source /etc/profile

RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

#ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
#RUN chmod +x /usr/local/bin/install-php-extensions && sync
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

#RUN pecl search swoole

RUN install-php-extensions gd pdo_mysql bcmath opcache pcntl zip redis mcrypt ssh2 swoole sockets mongodb

# 默认关闭一些扩展
RUN cd /usr/local/etc/php/conf.d && rm -rf docker-php-ext-swoole.ini

RUN echo "export TERM=xterm" >> /root/.bashrc \
    && rm -rf /usr/local/etc/php-fpm.conf \
    && mkdir /php \
    && ln -s /php/php.ini /usr/local/etc/php/php.ini \
    && ln -s /php/php-fpm.conf /usr/local/etc/php-fpm.conf

WORKDIR /www

CMD php-fpm
