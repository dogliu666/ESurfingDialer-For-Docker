# ESurfingDialer-For-Docker 

广东电信天翼校园登录认证脚本，适用于 OpenWrt，通过 Docker 一键搭建。

## 项目简介

本项目基于 [Rsplwe](https://github.com/Rsplwe) 大佬的 [ESurfingDialer](https://github.com/Rsplwe/ESurfingDialer) 项目，在 Docker 环境中运行，参考了 [EricZhou05](https://github.com/EricZhou05) 大佬的 [教程](https://github.com/EricZhou05/ESurfingDialerTutorial) 完成的一键配置脚本。本地编译保证了最大化适配。

### 功能
- [x] 在线脚本
- [ ] 离线脚本

## 在线运行

**注意**：需要能够正常拉取 Docker 镜像的网络环境。

### 使用方法：一键打包 Docker 镜像

1. 在终端输入以下命令下载并运行脚本 `auto.sh`：
   ```bash
   curl -O https://raw.githubusercontent.com/dogliu666/ESurfingDialer-For-Docker/main/auto.sh && bash auto.sh
   ```

2. 脚本开始执行，此时会自动构建并运行镜像。
   > **注意**：此过程耗时取决于主机性能。

3. 在提示 `请输入账号和密码` 时，输入天翼校园网账号和密码。
   > **注意**：请在账号和密码之间使用空格分隔。例如，校园网账号为 `account`，密码为 `password`，则输入 `account password`。

4. 在终端输入以下命令查看是否成功连接天翼校园网：
   ```bash
   docker logs -f dialer-client
   ```
   若输出 `INFO [com.rsplwe.esurfing.Client] (Client:**) - The login has been authorized.` 则表示已成功认证天翼校园网。
   
   若输出 `INFO [com.rsplwe.esurfing.Client] (Client:**) - The network has been connected.`则表示已成功连接网络。

## 离线运行（兼容性测试中）

暂未完成离线部署。建议在线部署，为 OpenWrt 设备提供网络，以实现在线部署。

## 成功运行后

### 查看 Docker 容器
```bash
docker ps -a
```

### 停止天翼校园认证
```bash
docker stop dialer-client
```

### 删除 Docker 容器
```bash
docker rm dialer-client
```

### 删除下载的文件（若存储空间不足）
```bash
cd /root
rm -f auto.sh
rm -rf /root/Dialer
rm -f /root/Dialer.zip
rm -f Dialer.tar
rm -f Config.txt
```
