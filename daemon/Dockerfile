FROM timeerror/php:7.4.29-ffmpeg4.4

RUN apk add --no-cache supervisor

WORKDIR /app
ENTRYPOINT [""]
CMD /usr/bin/supervisord -c /supervisor/supervisord.conf -n
