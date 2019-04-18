FROM blitzprog/archlinux

# Environment
ENV GO111MODULE=on \
	GODEBUG=tls13=1 \
	PATH=/home/developer/go/bin:$PATH

# Packages
RUN pacman -Sy --noconfirm base-devel git git-lfs go nodejs npm vim zsh zsh-autosuggestions zsh-syntax-highlighting

# Sudo
RUN rm /etc/sudoers && \
	echo -e "root ALL=(ALL) ALL\n%wheel ALL=(ALL) ALL\n" > /etc/sudoers

# Add user
RUN groupadd -g 1000 developer && \
	useradd -m -u 1000 -g users -G developer,wheel -s /bin/zsh developer

# TypeScript
RUN npm i -g --production typescript

# Set user
USER developer
WORKDIR /home/developer

# Pack and run
RUN go install github.com/aerogo/pack && \
	go install github.com/aerogo/run && \
	go install golang.org/x/tools/cmd/goimports

# Zsh configuration
RUN git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /home/developer/.oh-my-zsh && \
	curl -so .zshrc https://raw.githubusercontent.com/blitzprog/home/master/.zshrc

ENTRYPOINT ["/bin/zsh"]