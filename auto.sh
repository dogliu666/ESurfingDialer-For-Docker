if ! unzip -tq Dialer.zip; then
    echo "Dialer.zip 文件无效或已损坏"
    exit 1
fi

# 解压缩 Dialer.zip 文件
unzip -o Dialer.zip -d /root/dialer
if [ $? -ne 0 ]; then
    echo "解压缩 Dialer.zip 失败"
    exit 1
fi
cd /root/dialer || { echo "目录 /root/Dialer 不存在"; exit 1; }

# 构建 Docker 容器
docker build -t dialer .
if [ $? -ne 0 ]; then
    echo "Docker 容器构建失败"
    exit 1
fi

# 导出 Docker 镜像
docker save -o dialer.tar dialer
if [ $? -ne 0 ]; then
    echo "Docker 镜像导出失败"
    exit 1
fi

# 加载 Docker 镜像
docker load -i ./dialer.tar
if [ $? -ne 0 ]; then
    echo "Docker 镜像加载失败"
    exit 1
fi

# 输入 校园网 账密
read -p "请输入账号: " account
read -sp "请输入密码: " pwd
echo

# 验证输入的账号和密码
if [ -z "$account" ] || [ -z "$pwd" ]; then
    echo "账号或密码不能为空"
    exit 1
fi

# 将输入的 账密 保存到 Config.txt 中
echo "account=$account" > Config.txt
echo "pwd=$pwd" >> Config.txt

# 从 Config.txt 文件中读取 account 和 pwd
source ./Config.txt

# 运行 docker run 命令
docker run -itd -e DIALER_USER="$account" -e DIALER_PASSWORD="$pwd" --name dialer-client --network host --restart=always dialer
if [ $? -ne 0 ]; then
    echo "Docker 容器运行失败"
    exit 1
fi

# 自动删除文件
cd ..
rm auto.sh
rm -f Dialer.zip
rm -f dialer.tar

echo "所有临时文件已删除"