# Dockerfile 解析说明

本文档解释了一个用于构建 **goctl + protoc 工具链环境** 的多阶段 Dockerfile。

---

## 第一阶段：构建阶段（builder）

```dockerfile
FROM golang:1.20-alpine AS builder
```
- 使用 **Go 1.20 Alpine** 镜像作为基础镜像。
- 起别名 **builder**，便于多阶段构建时引用。

```dockerfile
LABEL stage=gobuilder
```
- 添加标签，说明这是构建阶段。

```dockerfile
ENV CGO_ENABLED 0
ENV GOPROXY https://goproxy.cn,direct
```
- `CGO_ENABLED=0`：禁用 CGO，编译出的 Go 程序为 **静态链接**，更容易跨平台。
- `GOPROXY=https://goproxy.cn`：使用 Go 模块代理，加快依赖下载速度。

```dockerfile
RUN apk update --no-cache && apk add --no-cache tzdata
```
- 安装 `tzdata`，用于时区设置。

```dockerfile
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```
- 安装 **protobuf 插件**：
  - `protoc-gen-go`：将 `.proto` 文件编译成 Go 代码。
  - `protoc-gen-go-grpc`：生成 gRPC 相关的 Go 代码。
- 插件安装在 `/go/bin/`。

```dockerfile
WORKDIR /build
```
- 设置工作目录为 `/build`。

```dockerfile
ADD go.mod .
ADD go.sum .
RUN go mod download
```
- 添加 `go.mod` 和 `go.sum`，并提前下载依赖（构建加速）。

```dockerfile
COPY . .
RUN go build -ldflags="-s -w" -o /app/goctl ./goctl.go
```
- 复制源码，编译 `goctl.go`。
- 输出二进制文件到 `/app/goctl`。
- `-ldflags="-s -w"`：剥离符号表和调试信息，减小可执行文件体积。

---

## 第二阶段：运行阶段

```dockerfile
FROM golang:1.20-alpine
```
- 运行阶段依然基于 **Go 1.20 Alpine** 镜像（方便继续运行 Go 工具）。

```dockerfile
RUN apk update --no-cache && apk add --no-cache protoc
```
- 安装 `protoc` 编译器，用于编译 `.proto` 文件。

```dockerfile
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /usr/share/zoneinfo/Asia/Shanghai
COPY --from=builder /go/bin/protoc-gen-go /usr/bin/protoc-gen-go
COPY --from=builder /go/bin/protoc-gen-go-grpc /usr/bin/protoc-gen-go-grpc
```
- 从 `builder` 阶段复制：
  - **CA 证书**（保证 HTTPS 正常访问）。
  - **时区文件**（设置为上海时区）。
  - **`protoc-gen-go` 插件**。
  - **`protoc-gen-go-grpc` 插件**。

```dockerfile
ENV TZ Asia/Shanghai
```
- 设置容器的默认时区为上海。

```dockerfile
WORKDIR /app
COPY --from=builder /app/goctl /usr/bin/goctl
```
- 设置工作目录为 `/app`。
- 拷贝编译好的 `goctl` 可执行文件到 `/usr/bin/goctl`。

```dockerfile
CMD ["goctl"]
```
- 容器启动时默认执行 `goctl` 命令。

---

## 总结

该 Dockerfile 采用 **多阶段构建**：

1. **构建阶段**  
   - 编译生成 `goctl`。  
   - 安装并准备好 `protoc` 插件。  

2. **运行阶段**  
   - 使用轻量级运行镜像。  
   - 内置 `goctl`、`protoc` 及插件，开箱即用。  
   - 设置时区为 **Asia/Shanghai**。  

👉 最终镜像可直接用于 **proto 文件编译 + goctl 工具使用**，适合在 CI/CD 或开发环境中使用。

---
