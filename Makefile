GOPATH=$(shell go env GOPATH)

# Setting SHELL to bash allows bash commands to be executed by recipes.
# This is a requirement for 'setup-envtest.sh' in the test target.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

FILES=./external/proto/**/*.pb.go

gen-proto:
	protoc -I. \
      -I/usr/local/include \
      -I${GOPATH}/src/ \
      --go_out=plugins=grpc:../../../ \
      ./proto/**/*.proto

FILES = ./external/proto
add-tags: $(FILES)/**/*.pb.go
	@printf "Processing proto files...\n"
	for file in $^ ; do \
		protoc-go-inject-tag -input="$${file}"; \
	done
