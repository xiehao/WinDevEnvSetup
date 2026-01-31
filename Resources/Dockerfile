FROM archlinux:latest

# 1. 基础配置 + 官方包安装 + 立即清理
RUN echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm \
    base-devel gcc gdb cmake ninja clang lldb git fish sudo wget zip unzip pkgconf && \
    pacman -Scc --noconfirm

# 2. 仓库配置
RUN echo -e "\n[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf && \
    pacman -Sy --noconfirm archlinuxcn-keyring && \
    pacman -S --noconfirm paru && \
    pacman -Scc --noconfirm

# 3. 用户设置
RUN useradd -m -G wheel devel && \
    echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER devel
WORKDIR /home/devel

# 4. Paru 安装 codelldb + 清理缓存
RUN paru -S --noconfirm codelldb-bin && \
    rm -rf ~/.cache/paru

# 5. vcpkg 安装 + 清理
RUN git clone --depth 1 https://github.com/microsoft/vcpkg.git && \
    ./vcpkg/bootstrap-vcpkg.sh && \
    rm -rf ./vcpkg/.git  # 如果不需要更新 vcpkg，删掉 .git 文件夹能省几百MB

ENV VCPKG_ROOT=/home/devel/vcpkg
ENV PATH=$PATH:$VCPKG_ROOT

ENTRYPOINT ["/usr/bin/fish"]