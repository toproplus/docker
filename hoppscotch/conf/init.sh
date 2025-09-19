#! /bin/bash

# 手动复制配置文件，先修改好配置
# cp /home/core/docker/hoppscotch/conf/.env .env

# 首次启动需要初始化数据库
# 资料参考：https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build#running-migrations

/usr/bin/docker run --rm --net nginx-network --env-file .env hoppscotch/hoppscotch:latest sh -c "pnpm dlx prisma migrate deploy"
# /usr/bin/docker exec hoppscotch pnpm dlx prisma migrate deploy


# 搭建好自托管服务好，不建议通过浏览器使用（不好使），而是通过桌面版应用链接自托管hoppscotch服务来使用
# 桌面版链接自托管hoppscotch说明：https://docs.hoppscotch.io/documentation/clients/desktop#hoppscotch-self-hosted-edition-for-enterprise

