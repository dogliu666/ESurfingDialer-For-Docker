# ESurfingDialer-For-Docker 

广东电信天翼校园登录认证脚本，适用于 OpenWrt 和 iStoreOS，通过 Docker 一键搭建。

## 项目简介

本项目基于 [Rsplwe](https://github.com/Rsplwe) 大佬的 [ESurfingDialer](https://github.com/Rsplwe/ESurfingDialer) 项目，在 Docker 环境中运行，参考了 [EricZhou05](https://github.com/EricZhou05) 大佬的 [教程](https://github.com/EricZhou05/ESurfingDialerTutorial) 完成的一键配置脚本。本地编译保证了最大化适配。

### 功能
- [x] 在线脚本
- [x] 离线脚本

# 若路由器已接入互联网,选择[在线运行](https://github.com/dogliu666/ESurfingDialer-For-Docker#%E5%9C%A8%E7%BA%BF%E8%BF%90%E8%A1%8C), 若路由器未接入互联网, 选择[离线运行](https://github.com/dogliu666/ESurfingDialer-For-Docker#%E7%A6%BB%E7%BA%BF%E8%BF%90%E8%A1%8C)

# 在线运行

### 使用方法：一键打包 Docker 镜像
   在终端输入以下命令下载并运行脚本 `auto.sh`：
   ```bash
   curl -O https://raw.githubusercontent.com/dogliu666/ESurfingDialer-For-Docker/main/auto.sh && bash auto.sh
   ```

# 离线运行

1. 下载文件 [Dialer.zip](https://github.com/dogliu666/ESurfingDialer-For-Docker/releases/download/Latest/Dialer.zip) + [auto.sh](https://github.com/dogliu666/ESurfingDialer-For-Docker/releases/download/Latest/auto.sh) + [openjdk-23.tar](https://github.com/dogliu666/ESurfingDialer-For-Docker/releases/download/Latest/openjdk-23.tar) **总计3个文件**上传至设备上

2. 将 所下载的3个文件 上传至 设备 `/root`下，其文件结构为
```
.
├── auto.sh
├── openjdk-23.tar
└── Dialer.zip 
```

3. 使用指令以离线构建Docker容器
- 首先加载镜像文件`openjdk-23`
   ```bash
   docker load -i openjdk-23.tar
   ```
- 然后运行自动脚本
   ```bash
   bash  auto.sh
   ```
**在询问`文件 Dialer.zip 已存在。是否删除并重新下载？(y/n):`时, 选择 `n`**

## 脚本运行时
1. 脚本开始执行，此时会自动构建并运行镜像。
   > **注意**：此过程耗时取决于主机性能。

2. 在提示 `请输入账号和密码` 时，输入天翼校园网账号和密码。
   > **注意**：请在账号和密码之间使用空格分隔。例如，校园网账号为 `account`，密码为 `password`，则输入 `account password`。

3. 在终端输入以下命令查看是否成功连接天翼校园网：
   ```bash
   docker logs -f dialer-client
   ```
   若输出 `INFO [com.rsplwe.esurfing.Client] (Client:**) - The login has been authorized.` 则表示已成功认证天翼校园网。
   
   若输出 `INFO [com.rsplwe.esurfing.Client] (Client:**) - The network has been connected.`则表示已成功连接网络。
   
## 成功运行后

#### 查看 Docker 容器
```bash
docker ps -a
```

#### 停止天翼校园认证
```bash
docker stop dialer-client
```

#### 删除 Docker 容器
```bash
docker rm dialer-client
```

#### 删除下载的文件（若存储空间不足）
```bash
cd /root
rm -f auto.sh
rm -rf /root/Dialer
rm -f /root/Dialer.zip
rm -f Dialer.tar
rm -f Config.txt
```
