<!-- docker build --rm --platform linux/amd64 -t kevinwan/goctl:$(version) . -->

在 docker 中使用

docker run --rm -it -v $(pwd):/app andy/goctl-z-arm64:latest goctl --version

# 1. 参数逐段解释

## 1. docker run

启动一个新的容器。

## 2. --rm

容器退出后自动删除（避免堆积一堆无用容器）。

## 3. -it

    •	-i 交互模式，保持标准输入打开。
    •	-t 分配一个伪终端，让你可以像在本地一样交互运行命令。

## 4. -v $(pwd):/app

    •	把宿主机当前目录（$(pwd) 会展开为当前工作目录的绝对路径）挂载到容器的 /app 目录。
    •	这样你在本地写的代码或配置文件，容器里也能直接访问。

## 5. andy/goctl-z-arm64:latest

    •	要运行的镜像名。
    •	andy 是镜像仓库的命名空间（可能是你的 Docker Hub 用户名或本地 tag）。
    •	goctl-z-arm64 是镜像名，带 arm64，说明这是为 ARM 架构（Apple M1/M2/M3 芯片或 ARM 服务器）构建的。
    •	:latest 是标签，表示使用该镜像的最新版本。

## 6. goctl --version

    •	这是在容器内执行的命令。
    •	进入镜像后，直接调用镜像里安装好的 goctl 程序，并带上 --version 参数，输出版本号。

# 执行效果

这条命令最终会：

1. 启动一个临时容器（基于 andy/goctl-z-arm64:latest）。
2. 把你当前目录挂载到 /app。
3. 在容器里运行：
4. 打印出 goctl 的版本号。
   goctl --version
5. 容器执行完就自动删除。

# 可运行的软件

docker run --rm -it -v $(pwd):/app andy/goctl-z-arm64:latest goctl --version
docker run --rm -it -v $(pwd):/app andy/goctl-z-arm64:latest protoc --version
docker run --rm -it -v $(pwd):/app andy/goctl-z-arm64:latest protoc-gen-go --version
docker run --rm -it -v $(pwd):/app andy/goctl-z-arm64:latest protoc-gen-go-grpc --version

# 查看镜像内容

docker run -it --rm <image_name> sh

docker run -it --rm andy/goctl-z-arm64:latest sh
