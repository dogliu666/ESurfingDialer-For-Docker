#!/bin/bash
cd /root

# 检查是否安装了 Docker
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装"
    rm -f auto.sh
    exit 1
fi

# 检查Dialer.zip文件是否存在
FILE="Dialer.zip"

if [ -f "$FILE" ]; then
    read -p "文件 $FILE 已存在。是否删除并重新下载？(y/n): " choice
    case "$choice" in 
        y|Y ) 
            rm -rf /root/Dialer
            read -p "确认删除 /root/Dialer 目录及其所有内容吗？(y/n): " confirm
            if [[ "$confirm" =~ ^[Yy]$ ]]; then
                rm -rf /root/Dialer
                rm -f Dialer.tar
                echo "删除 /root/Dialer 目录及其所有内容"
            else
                echo "跳过删除 /root/Dialer 目录"
            fi
            ;;
        n|N ) 
            echo "跳过下载"
            ;;
        * ) 
            echo "无效选择，跳过下载"
            ;;
    esac
fi

if [ ! -f "$FILE" ]; then
    echo "下载 Dialer.zip 文件"
    wget https://github.com/dogliu666/ESurfingDialer-For-Docker/releases/download/Latest/Dialer.zip
    if [ $? -ne 0 ]; then
        echo "下载 Dialer.zip 失败"
        exit 1
    fi
fi

# 解压缩 Dialer.zip 文件
if ! unzip -o Dialer.zip -d /root/Dialer; then
    echo "解压缩 Dialer.zip 失败"
    rm -f Dialer.zip
    exit 1
fi

cd /root/Dialer || { echo "目录 /root/Dialer 不存在"; rm -f auto.sh； exit 1; }

# 输入 校园网 账密 并 保存到 Config.txt 文件
read -p "请输入账号和密码（用空格分隔）: " account pwd
# 验证输入的账号和密码
while [ -z "$account" ] || [ -z "$pwd" ]; do
    echo "账号或密码不能为空，请重新输入"
    read -p "请输入账号和密码（用空格分隔）: " account pwd
done

echo "account=$account" > Config.txt
echo "pwd=$pwd" >> Config.txt

# 构建 Docker 容器
docker build -t dialer .
if [ $? -ne 0 ]; then
    echo "Docker 容器构建失败"
    rm -f auto.sh
    exit 1
fi

echo "正在导出镜像(此过程用时可能较长)"
# 导出 Docker 镜像
docker save -o Dialer.tar dialer
if [ $? -ne 0 ]; then
    echo "Docker 镜像导出失败"
    rm -f auto.sh
    exit 1
fi

# 加载 Docker 镜像
docker load -i ./Dialer.tar
if [ $? -ne 0 ]; then
    echo "Docker 镜像加载失败"
    rm -f auto.sh
    exit 1 
fi
echo "Docker 镜像加载成功"

# 从 Config.txt 文件中读取 account 和 pwd
. /root/Dialer/Config.txt

# 运行 docker run 命令
docker run -itd -e DIALER_USER="$account" -e DIALER_PASSWORD="$pwd" --name dialer-client --network host --restart=always dialer

echo "尝试运行 Docekr 容器"
sleep 5

# 检查 Docker 容器是否正在运行
if docker ps | grep -q dialer-client; then
    echo "Docker 容器运行成功"
else
    echo "Docker 容器未运行"
    echo "5s 后再次尝试运行 Docker 容器"
    sleep 5
    if docker ps | grep -q dialer-client; then
        echo "Docker 容器正在运行"
    else
        echo "Docker 容器未运行，请检查"
        rm -f auto.sh
        exit 1
    fi
fi
