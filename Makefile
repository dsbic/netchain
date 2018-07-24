# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: net android ios net-cross swarm evm all test clean
.PHONY: net-linux net-linux-386 net-linux-amd64 net-linux-mips64 net-linux-mips64le
.PHONY: net-linux-arm net-linux-arm-5 net-linux-arm-6 net-linux-arm-7 net-linux-arm64
.PHONY: net-darwin net-darwin-386 net-darwin-amd64
.PHONY: net-windows net-windows-386 net-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

net:
	build/env.sh go run build/ci.go install ./cmd/net
	@echo "Done building."
	@echo "Run \"$(GOBIN)/net\" to launch net."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/net.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Geth.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

net-cross: net-linux net-darwin net-windows net-android net-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/net-*

net-linux: net-linux-386 net-linux-amd64 net-linux-arm net-linux-mips64 net-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-*

net-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/net
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep 386

net-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/net
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep amd64

net-linux-arm: net-linux-arm-5 net-linux-arm-6 net-linux-arm-7 net-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep arm

net-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/net
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep arm-5

net-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/net
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep arm-6

net-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/net
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep arm-7

net-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/net
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep arm64

net-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/net
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep mips

net-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/net
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep mipsle

net-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/net
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep mips64

net-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/net
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/net-linux-* | grep mips64le

net-darwin: net-darwin-386 net-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/net-darwin-*

net-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/net
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/net-darwin-* | grep 386

net-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/net
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/net-darwin-* | grep amd64

net-windows: net-windows-386 net-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/net-windows-*

net-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/net
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/net-windows-* | grep 386

net-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/net
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/net-windows-* | grep amd64
