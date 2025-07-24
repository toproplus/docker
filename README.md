# CoreOS Docker

让你更便捷、系统化的使用Docker管理你的服务，一键定制你的环境   
需借助 Systemd 服务管理，支持此服务的 Linux 系统都可安装，建议使用 Centos7+ 系统  

## Step.1 Install Docker

请自行安装Docker  
参考教程：https://www.kancloud.cn/wenshunbiao/wenshunbiao/1310878

## Step.2 Install CoreOS Docker

请使用root用户安装，忽略一些常规性的报错输出

    # useradd -d /home/core -m core && cd /home/core
    # git clone https://github.com/toproplus/docker.git
    # chmod -R 777 docker/shell && export PATH="/home/core/docker/shell:$PATH"
    # install_coreos
    # cd docker && git config core.fileMode false

安装到此结束，以下是一些使用示例或提示。
-----

## 一些常用服务及快捷命令列表

在 /home/core/docker 预先封装了大量服务，文件夹名称即是服务名称  
所有服务都安装在 /home/core/data 目录，需要修改服务的配置请在这里修改，改完使用 `s service_name` 重启生效  

以 redis 为例，安装 redis 后，在 /home/core/data/redis 下能看到以下文件：  
`redis.conf` `redis.service`  
`redis.conf` 是 redis 的配置文件  
`redis.service` 是启动 redis 服务所使用的启动参数，修改映射端口、目录等启动参数在这个文件修改

- 常用服务
  - `mysql`
  - `nginx`
  - `redis`
  - `daemon` supervisor守护进程服务
  - `ofelia` 秒级定时器，可替代crontab，能和docker容器更方便的交互，https://github.com/mcuadros/ofelia
  - `v2ray` 飞机场
  - ...

更多快捷命令请查看 /home/core/docker/shell 

- 快捷命令
  - `dps`              # 显示所有docker服务
  - `dpp`              # 显示所有docker服务映射端口
  - `i service_name`   # 安装服务
  - `s service_name`   # 启动/重启 服务
  - `p service_name`   # 停止服务
  - `d service_name`   # 进入服务容器
  - `j service_name`   # 查看服务历史记录日志
  - `jf service_name`  # 滚动查看服务日志
  - `atop`             # 查看系统负载
  - `iotop`            # 查看系统I/O
  - `fio`              # 测试系统I/O
  - `docker_mirror_aliyun`  # 为docker配置阿里云源
  - ...

## install service

    i php74                       # install php server
    i nginx                       # install nginx share
    i redis                       # install redis server

## start/restart service

    s php74                       # start/restart php server
    s nginx                       # start/restart nginx share
    s redis                       # start/restart redis server

## stop service

    p php74                       # stop php server
    p nginx                       # stop nginx share
    p redis                       # stop redis server

## 进阶

1. 扩展服务非常简单，如新增一个 nas 服务，您可以复制一份已有的服务来修改，如 `cp -r redis nas`  
2. 接着修改里面的文件，如Dockerfile的构建内容、redis.service重命名为nas.service并修改里面的内容和换成你自己的镜像  
3. 潜规则：conf目录下的配置文件，安装服务的时候会一起copy到/home/core/data/nas下  
4. 然后可以着手build自己的镜像并推送到云仓库  

这样一个服务就扩展完毕啦，修改原有服务的话，直接修改原文件就好了，然后自己重新build一个镜像，并把service文件里面的镜像替换成自己的

## Fork Me

1. 如果您觉得本项目不错，当现有服务不能完全适合您，或者没有您需要的服务时，您可以选择 Fork 原始仓库[wenshunbiao/docker](https://github.com/wenshunbiao/docker)，进行二次创作
2. 如果原始仓库没有本仓库的某个服务，你又希望使用，可以把你 Fork 的仓库 `clone` 到本地，然后合并本仓库

```bash
# 为你的仓库设置一个远程连接，这个远程连接为本仓库
git remote add toproplus https://github.com/toproplus/docker.git
# 合并本仓库到你的仓库，先拉取本仓库所有数据
git fetch toproplus
# 切换到你想要合并更改的目标分支（如果有需要）
# git checkout -b toproplus
# 合并本仓库master分支到你的分支，如果有冲突则解决冲突
git merge toproplus/master
# 合并完成后，就可以推送到你的远程Fork仓库了（给本仓库一个star，让更多的人知道）
git push origin master
```

## License

The CoreOS Docker is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
