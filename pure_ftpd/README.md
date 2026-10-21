### **进入容器创建用户** **：**

```bash
docker exec -it pure_ftpd bash
```

### **在容器内添加虚拟用户** **：**

使用 `pure-pw` **工具为每个用户分配独立的目录和系统映射用户（这里使用默认的** `ftpuser`）：

```bash

# 宿主机，设置目录权限
sudo chown -R 1000:1000 /home/core/data/www/user1

# 进入容器执行
# 创建 user1，限制在 /ftp/user1 目录, 分配和宿主机相同的用户组ID，否则无写入权限
# 注：执行 pure-pw useradd 时，系统会提示你输入并确认密码
pure-pw useradd user1 -u 1000 -g 1000 -d /ftp/user1


# 创建 user2，限制在 /ftp/user2 目录
pure-pw useradd user2 -u ftpuser -g ftpgroup -d /ftp/user2
# 更新用户
pure-pw usermod user2 -u 1000 -g 1000 -d /ftp/user2

# 重置密码
pure-pw passwd user1

# 删除用户
pure-pw userdel user1

# 查看当前在线用户
pure-ftpd pure-ftpwho
```

### **更新用户数据库** **：**

每次添加或修改用户后，**必须**执行以下命令使配置生效：

```bash
pure-pw mkdb
```

### 客户端连接：

使用 FileZilla 等客户端连接时，协议选择 FTP，加密选择“普通FTP”，传输模式务必勾选“被动模式 (PASV)”


### 使用TLS证书:

```bash

# 在宿主机上生成
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /home/core/data/pure_ftpd/ssl/private/pure-ftpd.pem \
  -out /home/core/data/pure_ftpd/ssl/private/pure-ftpd.pem \
  -subj "/C=CN/CN=47.113.200.26"

# 给权限
sudo chmod 755 /home/core/data/pure_ftpd/ssl/private/pure-ftpd.pem

# 参考 pure_ftpd_tls.service 的配置
```
