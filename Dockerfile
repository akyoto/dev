FROM blitzprog/archlinux

# Environment
ENV GO111MODULE=on \
	GODEBUG=tls13=1 \
	PATH=/root/go/bin:$PATH

# DNS settings
RUN echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolv.conf

# Packages
RUN pacman -Sy --noconfirm base-devel git git-lfs go nodejs npm zsh zsh-autosuggestions zsh-syntax-highlighting

# TypeScript and Pure
RUN npm i -g --production typescript

# Linter
RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(go env GOPATH)/bin v1.16.0

# Pack and run
RUN go install github.com/aerogo/pack && \
	go install github.com/aerogo/run

# Pure prompt
RUN curl -so /usr/share/zsh/functions/Prompts/prompt_pure_setup https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh && \
	curl -so /usr/share/zsh/functions/Prompts/async https://raw.githubusercontent.com/sindresorhus/pure/master/async.zsh

# Zsh configuration
RUN git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh && \
	curl -so /root/.zshrc https://raw.githubusercontent.com/akyoto/home/master/.zshrc && \
	curl -so /root/.zshenv https://raw.githubusercontent.com/akyoto/home/master/.zshenv

# Create empty working directory
WORKDIR /my

ENTRYPOINT ["/bin/zsh"]