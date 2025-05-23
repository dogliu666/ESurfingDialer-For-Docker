#!/bin/bash
cd /root

# 检查是否安装了 Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "\e[31mDocker 未安装\e[0m"
        rm -f auto.sh
        exit 1
    fi
}

# 检查并处理 Dialer.zip 文件
download_dialer_zip() {
    local FILE="Dialer.zip"
    if [ -f "$FILE" ]; then
        echo -e "\e[34m文件 $FILE 已存在。是否删除并重新下载？(y/n): \e[0m"
        read -p "请输入选择 (y/n): " choice
        case "$choice" in 
            y|Y ) 
                rm -rf /root/Dialer
                echo -e "\e[34m确认删除 /root/Dialer 目录及其所有内容吗？(y/n): \e[0m"
                read -p "请输入确认 (y/n): " confirm
                case "$confirm" in
                    y|Y )
                        if [ -f "Dialer.tar" ]; then
                            rm -f Dialer.tar
                        fi
                        echo -e "\e[32m删除 /root/Dialer 目录及其所有内容\e[0m"
                        ;;
                    * )
                        echo -e "\e[34m跳过删除 /root/Dialer 目录\e[0m"
                        ;;
                esac
                rm -f "$FILE"
                ;;
            n|N ) 
                echo -e "\e[34m跳过下载\e[0m"
                ;;
            * ) 
                echo -e "\e[31m无效选择，跳过下载\e[0m"
                ;;
        esac
    fi
    if [ ! -f "$FILE" ]; then
        echo -e "\e[34m下载 Dialer.zip 文件\e[0m"
        wget https://github.com/dogliu666/ESurfingDialer-For-Docker/releases/download/Latest/Dialer.zip
        if [ $? -ne 0 ]; then
            echo -e "\e[31m下载 Dialer.zip 失败\e[0m"
            exit 1
        fi
    fi
}

# 解压 Dialer.zip
unzip_dialer() {
    if ! unzip -o Dialer.zip -d /root/Dialer; then
        echo -e "\e[31m解压缩 Dialer.zip 失败\e[0m"
        rm -f Dialer.zip
        exit 1
    fi
}

# 输入账号密码并保存
input_account_pwd() {
    cd /root/Dialer || { echo -e "\e[31m目录 /root/Dialer 不存在\e[0m"; rm -f auto.sh; exit 1; }
    echo -e "\e[34m请输入 账号 和 密码（用空格分隔）: \e[0m"
    read -p "" account pwd
    while [ -z "$account" ] || [ -z "$pwd" ]; do
        echo -e "\e[31m账号或密码不能为空，请重新输入\e[0m"
        echo -e "\e[34m请输入 账号 和 密码（用空格分隔）: \e[0m"
        read -p "" account pwd
    done
    echo "account=$account" > Config.txt
    echo "pwd=$pwd" >> Config.txt
}

# 构建 Docker 镜像
build_docker_image() {
    docker build -t dialer .
    if [ $? -ne 0 ]; then
        echo -e "\e[31mDocker 容器构建失败\e[0m"
        rm -f auto.sh
        exit 1
    fi
}

# 导出并加载 Docker 镜像
export_and_load_image() {
    echo -e "\e[34m正在导出镜像(此过程用时可能较长)\e[0m"
    docker save -o Dialer.tar dialer
    if [ $? -ne 0 ]; then
        echo -e "\e[31mDocker 镜像导出失败\e[0m"
        rm -f auto.sh
        exit 1
    fi
    docker load -i ./Dialer.tar
    if [ $? -ne 0 ]; then
        echo -e "\e[31mDocker 镜像加载失败\e[0m"
        rm -f auto.sh
        exit 1 
    fi
    echo -e "\e[32mDocker 镜像加载成功\e[0m"
}

# 运行 Docker 容器
run_docker_container() {
    . /root/Dialer/Config.txt
    docker run -itd -e DIALER_USER="$account" -e DIALER_PASSWORD="$pwd" --name dialer-client --network host --restart=always dialer
    echo -e "\e[34m尝试运行 Docker 容器\e[0m"
    sleep 5
    if docker ps | grep -q dialer-client; then
        echo -e "\e[32mDocker 容器运行成功\e[0m"
    else
        echo -e "\e[31mDocker 容器未运行\e[0m"
        echo -e "\e[31m5s 后再次尝试运行 Docker 容器\e[0m"
        sleep 5
        if docker ps | grep -q dialer-client; then
            echo -e "\e[32mDocker 容器正在运行\e[32m"
        else
            echo -e "\e[31mDocker 容器未运行，请检查\e[0m"
            rm -f auto.sh
            exit 1
        fi
    fi
}

# 主流程
main() {
    check_docker
    download_dialer_zip
    unzip_dialer
    input_account_pwd
    build_docker_image
    export_and_load_image
    run_docker_container
}

main
