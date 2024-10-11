#!/bin/bash
cd /root

# 使用 curl 下载文件，并跟随重定向
curl -L -o Dialer.zip https://github.com/dogliu666/ESurfingDialer-For-Docker/releases/download/Latest/Dialer.zip

# 检查文件是否下载成功
if [ $? -ne 0 ]; then
    echo "下载 Dialer.zip 文件失败"
    exit 1
fi

# 检查文件大小是否合理
if [ $(stat -c%s "Dialer.zip") -le 100 ]; then
    echo "下载的 Dialer.zip 文件大小异常"
    exit 1
fi

# 检查文件是否为有效的 zip 文件
if ! unzip -tq Dialer.zip; then
    echo "Dialer.zip 文件无效或已损坏"
    exit 1
fi

# 解压缩 dialer.zip 文件
unzip /root/Dialer.zip
cd /root/Dialer

# 构建 Docker 容器
docker build -t Dialer .

# 导出 Docker 镜像
docker save -o Dialer.tar Dialer

# 加载镜像
docker load -i ./Dialer.tar

# 输入 校园网 账密
read -p "请输入账号: " account
read -p "请输入密码: " pwd
echo

# 将输入的 账密 保存到 Config.txt 中
echo "account=$account" > Config.txt
echo "pwd=$pwd" >> Config.txt

# 从 Config.txt 文件中读取 account 和 pwd
source ./Config.txt

# 运行 docker run 命令
docker run -itd -e DIALER_USER="$account" -e DIALER_PASSWORD="$pwd" --name dialer-client --network host --restart=always dialer