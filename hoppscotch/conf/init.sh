#! /bin/bash

# 先修改好配置文件
# cp /home/core/docker/hoppscotch/conf/.env .env

# 首次启动后需要初始化数据库
# 资料参考：https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build#running-migrations

/usr/bin/docker run --rm --net nginx-network --env-file .env hoppscotch/hoppscotch:latest sh -c "pnpm dlx prisma migrate deploy"
# /usr/bin/docker exec hoppscotch pnpm dlx prisma migrate deploy

