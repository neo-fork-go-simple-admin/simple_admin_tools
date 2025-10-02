GO ?= go
GOFMT ?= gofumpt "-s"
GOFILES := $(shell find . -name "*.go")
LDFLAGS := -s -w


.PHONY: tools
tools: # Install the necessary tools | 安装必要的工具
	go clean -modcache # 清理模块缓存，避免冲突
	# 安装最新版本的工具
	$(GO) install github.com/golangci/golangci-lint/cmd/golangci-lint@latest;
	$(GO) install golang.org/x/tools/cmd/goimports@latest;
	$(GO) install mvdan.cc/gofumpt@latest;
# 	$(GO) install github.com/go-swagger/go-swagger/cmd/swagger@latest;
	$(GO) install github.com/go-swagger/go-swagger/cmd/swagger@v0.30.5

# 格式化
.PHONY: fmt
fmt: # Format the codes | 格式化代码
	$(GOFMT) -w $(GOFILES)


# # 必须在 go 项目的 mod 文件同目录
# .PHONY: lint
# lint: # Run go linter | 运行代码错误分析
# 	golangci-lint run -D staticcheck


# 清理 DS_Store 文件
# 在任意目录下执行，清理当前目录及子目录
.PHONY: clean_store
clean_store:
	find . -name ".DS_Store" -type f -print -delete

# 如果需要从 git 仓库中删除这些文件，可以使用下面的命令
# 	find . -name .DS_Store -print0 | xargs -0 git rm -f --ignore-unmatch


# 删除本地所有被 .gitignore 忽略的文件

# •	-f 表示强制执行（必须加上，否则不会删除）。
# •	-d 表示连目录也一起清理。
# •	-X 表示只删除 被 .gitignore 忽略的文件。

# git clean -fdnX   # 仅列出会删除的被忽略文件
# git clean -fdnx   # 仅列出会删除的所有未跟踪文件
.PHONY: clean_git
clean_git:
	git clean -fdX


go build -o ./bin/goctl-z ./tools/goctl/goctl.go 

go build ./goctl.go  -o  ./bin/goctl-z


go build  -o ../../bin/goctl-z ./goctl.go 