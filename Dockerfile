FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools
RUN apt update && \
    apt full-upgrade -y && \
    apt install -y \
    vim \
    git \
    curl \
    htop \
    nmap \
    software-properties-common \
    unzip \
    locales \
    locales-all

# Generate the locale
RUN locale-gen en_US.UTF-8

# Set environment variables for locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install zsh and oh-my-zsh
RUN apt install -y zsh && \
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install neovim using appimage
RUN add-apt-repository ppa:neovim-ppa/unstable && \
    apt update && \
    apt install -y neovim

# Copy dotfiles
COPY ./nvim/ /root/.config/nvim/
COPY . /root/code/dotfiles

# Go
RUN curl -fsSL https://go.dev/dl/go1.22.3.linux-amd64.tar.gz -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz

# Rust
RUN curl -fsSL https://sh.rustup.rs -sSf -o /tmp/rustup.sh && \
    zsh /tmp/rustup.sh -y && \
    rm /tmp/rustup.sh

# Node
RUN export SHELL=/bin/zsh && \
    curl -fsSL https://fnm.vercel.app/install | zsh && \
    zsh -c "source /root/.zshrc && fnm use --install-if-missing 20"

# Dotnet
RUN apt install -y dotnet-sdk-8.0

# Compilers and build tools
RUN apt install -y \
    gcc

# Update PATH
RUN echo "export PATH=\$PATH:/root/.cargo/bin" >> /root/.zshrc && \
    echo "export PATH=\$PATH:/usr/local/go/bin" >> /root/.zshrc

WORKDIR /root/code

CMD ["zsh"]
