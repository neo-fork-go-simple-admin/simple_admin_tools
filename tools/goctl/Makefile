GOPATH?=$(shell go env GOPATH)
# Build_Path=$(GOPATH)
Build_Path?="../.."
# Build_Name?="goctls"
Build_Name?="goctls-z"

build:
	go build -ldflags="-s -w" -o goctls goctl.go
	cp goctls $(Build_Path)/bin/$(Build_Name)
	goctls template clean
	goctls template init
# 	$(if $(shell command -v upx), upx goctl)	
	

mac:
	@echo ${Build_Path}
	GOOS=darwin go build -ldflags="-s -w" -o goctls goctl.go
	$(if $(shell command -v strip), strip goctls)
	mv goctls $(Build_Path)/bin/$(Build_Name)

win:
	GOOS=windows go build -ldflags="-s -w" -o goctls.exe goctl.go
	$(if $(shell command -v upx), upx goctl.exe)
	mv goctls.exe $(Build_Path)/bin/$(Build_Name).exe

linux:
	GOOS=linux go build -ldflags="-s -w" -o goctls goctl.go
	$(if $(shell command -v upx), upx goctl-linux)
	mv goctls $(Build_Path)/bin/$(Build_Name)

# make image version=1.0.0
image:
	docker build --rm --platform linux/amd64 -t kevinwan/goctl:$(version) .
	docker tag kevinwan/goctl:$(version) kevinwan/goctl:latest
	docker push kevinwan/goctl:$(version)
	docker push kevinwan/goctl:latest
	docker build --rm --platform linux/arm64 -t kevinwan/goctl:$(version)-arm64 .
	docker tag kevinwan/goctl:$(version)-arm64 kevinwan/goctl:latest-arm64
	docker push kevinwan/goctl:$(version)-arm64
	docker push kevinwan/goctl:latest-arm64

Docker_Local_Path?="../.."
Build_Name_Goctl?="goctl-z"
# make image_local version=1.0.0
image_local:
	docker build --rm --platform linux/amd64 -t andy/$(Build_Name_Goctl)-amd64:$(version) .
	docker tag andy/$(Build_Name_Goctl)-amd64:$(version) andy/$(Build_Name_Goctl)-amd64:latest

# 	保存到文件	
	docker save -o $(Build_Path)/image/$(Build_Name_Goctl)-amd64:$(version).tar andy/$(Build_Name_Goctl)-amd64:$(version)
	docker save -o $(Build_Path)/image/$(Build_Name_Goctl)-amd64:latest.tar andy/$(Build_Name_Goctl)-amd64:latest

# 	提到仓库
# 	docker push kevinwan/goctl:$(version)
# 	docker push kevinwan/goctl:latest

	docker build --rm --platform linux/arm64 -t andy/$(Build_Name_Goctl)-arm64:$(version) .
	docker tag andy/$(Build_Name_Goctl)-arm64:$(version) andy/$(Build_Name_Goctl)-arm64:latest

# 	保存到文件	
	docker save -o $(Build_Path)/image/$(Build_Name_Goctl)-arm64:$(version).tar andy/$(Build_Name_Goctl)-arm64:$(version)
	docker save -o $(Build_Path)/image/$(Build_Name_Goctl)-arm64:latest.tar andy/$(Build_Name_Goctl)-arm64:latest

# 	docker push kevinwan/goctl:$(version)-arm64
# 	docker push kevinwan/goctl:latest-arm64

# make image_local_load version=1.0.0
image_local_load:
	docker load -i $(Build_Path)/image/$(Build_Name_Goctl)-amd64:$(version).tar
	docker load -i $(Build_Path)/image/$(Build_Name_Goctl)-amd64:latest.tar

	docker load -i $(Build_Path)/image/$(Build_Name_Goctl)-arm64:$(version).tar
	docker load -i $(Build_Path)/image/$(Build_Name_Goctl)-arm64:latest.tar

# image_local_test:
# 运行测试
# 	docker run --rm -it -v $(pwd):/app andy/goctl-z-arm64:latest goctl --version




