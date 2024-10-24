#!/bin/bash
cd /root

wget https://github.com/dogliu666/ESurfingDialer-For-Docker/releases/download/Latest/Dialer.zip

# 检查文件是否存在
if [ ! -f "Dialer.zip" ]; then
    echo "Dialer.zip 文件不存在"
    exit 1
fi

# 解压缩 Dialer.zip 文件
if ! unzip -tq Dialer.zip; then
    echo "解压缩 Dialer.zip 失败"
    exit 1
fi

unzip -o Dialer.zip -d /root/Dialer
if [ $? -ne 0 ]; then
    echo "解压缩 Dialer.zip 失败"
    exit 1
fi

cd /root/Dialer || { echo "目录 /root/Dialer 不存在"; exit 1; }

# 构建 Docker 容器
docker build -t dialer .
if [ $? -ne 0 ]; then
    echo "Docker 容器构建失败"
    exit 1
fi

echo "正在导出镜像(此过程用时可能较长)"
# 导出 Docker 镜像
docker save -o Dialer.tar dialer
if [ $? -ne 0 ]; then
    echo "Docker 镜像导出失败"
    exit 1
fi

# 加载 Docker 镜像
docker load -i ./Dialer.tar
if [ $? -ne 0 ]; then
    echo "Docker 镜像加载失败"
    exit 1 
fi
echo "Docker 镜像加载成功"

# 输入 校园网 账密 并 保存到 Config.txt 文件
read -p "请输入账号和密码（用空格分隔）: " account pwd

# 验证输入的账号和密码
while [ -z "$account" ] || [ -z "$pwd" ]; do
    echo "账号或密码不能为空，请重新输入"
    read -p "请输入账号和密码（用空格分隔）: " account pwd
done

# 保存到 Config.txt 文件
echo "account=$account" > Config.txt
echo "pwd=$pwd" >> Config.txt

# 从 Config.txt 文件中读取 account 和 pwd
. /root/Dialer/Config.txt

# 运行 docker run 命令
docker run -itd -e DIALER_USER="$account" -e DIALER_PASSWORD="$pwd" --name dialer-client --network host --restart=always dialer

echo "Docker 容器运行成功"
