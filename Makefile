APP_NAME=app 								#place app name here
REGISTRY=quay.io/inezhinskiy				#place your registry
HOST_OS=$(shell go env GOOS)
HOST_ARCH=$(shell go env GOARCH)
IMAGE_TAG=$(REGISTRY)/$(APP_NAME)-$(HOST_OS)-$(HOST_ARCH)
format:
	gofmt -s -w ./ 

get:
	go get

lint:
	golint

test:
	go test -v

linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/$(APP_NAME)-linux-amd64 .

arm:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o bin/$(APP_NAME)-linux-arm64 .

macos:
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -o bin/$(APP_NAME)-darwin-arm64 .

windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o bin/$(APP_NAME)-windows-amd64.exe .

image:
	docker build . -t $(IMAGE_TAG) \
		--build-arg APP_NAME=$(APP_NAME) \
		--build-arg HOST_ARCH=$(HOST_ARCH)

push:
	docker push ${IMAGE_TAG}
clean:
	rm -rf bin/
	docker rmi ${IMAGE_TAG}
