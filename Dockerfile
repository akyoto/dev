FROM golang:1.12.4-alpine

# Environment
ENV GO111MODULE on
ENV GODEBUG tls13=1
ENV GOPATH /home/developer/go
ENV PATH $GOPATH/bin:$PATH

# Packages
RUN apk update && \
	apk upgrade && \
	apk --no-cache add bash ca-certificates curl gcc git musl-dev nodejs npm

# Git LFS
RUN LFS_VERSION=2.7.1 && \
	mkdir lfs && \
	curl -s -L "https://github.com/git-lfs/git-lfs/releases/download/v$LFS_VERSION/git-lfs-linux-amd64-v$LFS_VERSION.tar.gz" | tar -C ./lfs -xz && \
	./lfs/install.sh && \
	rm -rf lfs

# NPM and TypeScript
RUN npm i -g --production npm && \
	npm i -g --production typescript

# Add user
RUN addgroup -g 1000 developer && \
	adduser -D -u 1000 -G developer developer

# Set user
USER developer
WORKDIR /home/developer

# Pack and run
RUN mkdir /home/developer/go && \
	go install github.com/aerogo/pack && \
	go install github.com/aerogo/run && \
	go install golang.org/x/tools/cmd/goimports

ENTRYPOINT ["/bin/bash"]