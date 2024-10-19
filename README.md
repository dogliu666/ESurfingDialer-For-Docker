# ESurfingDialer-For-Docker 

# 广东电信天翼校园登入认证脚本。在Docker一键搭建，适用于OpenWrt

## 基于 [Rsplwe](https://github.com/Rsplwe) 大佬的项目 [ESurfingDialer](https://github.com/Rsplwe/ESurfingDialer) ，在Docker环境中运行，参考了 [EricZhou05](https://github.com/EricZhou05) 大佬的 [教程](https://github.com/EricZhou05/ESurfingDialerTutorial) 完成的Docker一键配置脚本

- [x] 在线脚本
- [ ] 离线脚本

# 联网环境下运行（需要能够正常访问Docker的网络环境）

##### 使用方法：一键打包 Docker 镜像

1.在终端输入以下命令 下载脚本 `auto.sh`
```bash
wget https://raw.githubusercontent.com/dogliu666/ESurfingDialer-For-Docker/refs/heads/main/auto.sh
```

2.在终端输入以下命令 运行一键脚本
```bash
sh ./auto.sh
```

若出现 `Permission denied` 请在 终端 输入 
```bash
chmod u+r+x auto.sh
```
3.脚本开始执行，此时会自动 构建镜像 并 运行镜像 
  > **注意**：此过程 用时 取决于 主机性能

4.在提示 `请输入账号和密码` 时，输入 天翼校园网 账号 和 密码
  > **注意**：请在 账号 和 密码 之间 使用 **空格** 分离，例如 校园网 账号 为"account"，密码 为 "password"，则 输入"account password"

5.在 终端 输入以下命令查看是否成功连接 天翼校园网
```bash
 docker logs -f dialer-client
```
若输出 `INFO [com.rsplwe.esurfing.Client] (Client:**) - The login has been authorized.` 则代表 已成功 认证 天翼校园网

# 离线环境下运行（进行中）
### 空闲时间较少，抽空完成

# 成功运行后

##### 可查看Docker容器
```bash
docker ps -a
```

##### 若需要 停止运行 天翼校园认证
```
docker stop dialer-client
```

##### 若存储空间告急，可删除下载的文件
```bash
cd /root
rm -f auto.sh
rm -rf /root/Dialer
rm -f /root/Dialer.zip
rm -f dialer.tar
rm -f Config.txt
```
