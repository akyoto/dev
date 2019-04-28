FROM blitzprog/archlinux

# Environment
ENV GO111MODULE=on \
	GODEBUG=tls13=1 \
	PATH=/home/developer/go/bin:$PATH

# DNS settings
RUN echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolv.conf

# Packages
RUN pacman -Sy --noconfirm base-devel git git-lfs go nodejs npm vim zsh zsh-autosuggestions zsh-syntax-highlighting

# Sudo
RUN rm /etc/sudoers && \
	echo -e "root ALL=(ALL) ALL\n%wheel ALL=(ALL) NOPASSWD: ALL\n" > /etc/sudoers

# Add user
RUN useradd -m -G wheel -s /bin/zsh developer

# TypeScript
RUN npm i -g --production typescript

# Create /drone/src so that it belongs to "developer" (necessary for Drone CI)
RUN mkdir -p /drone/src && \
	chown -R developer:developer /drone

# Set user
USER developer
WORKDIR /home/developer

# Pack and run
RUN go install github.com/aerogo/pack && \
	go install github.com/aerogo/run

# Linter
RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(go env GOPATH)/bin v1.16.0

# Zsh configuration
RUN git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /home/developer/.oh-my-zsh && \
	curl -so .zshrc https://raw.githubusercontent.com/akyoto/home/master/.zshrc && \
	curl -so .zshenv https://raw.githubusercontent.com/akyoto/home/master/.zshenv

# Zsh pure prompt
RUN git clone https://aur.archlinux.org/zsh-pure-prompt.git /tmp/pure && \
	cd /tmp/pure && \
	makepkg -si --noconfirm && \
	rm -rf /tmp/pure

# Create empty working directory
WORKDIR /my

ENTRYPOINT ["/bin/zsh"]