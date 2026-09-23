# syntax=docker/dockerfile:1
FROM rust:trixie AS build
WORKDIR /workdir

SHELL ["/bin/bash","-c"]

# The Debian architectures to cross-compile for.
ARG _DEBIAN_ARCHES="amd64 arm64"
# The Rust targets corresponding to the Debian architectures above.
ARG _RUST_TARGETS="x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu"
# Disable interactive prompts when installing apt packages.
ARG DEBIAN_FRONTEND="noninteractive"

# The toolchain bundled with rust:trixie.
ENV RUSTUP_TOOLCHAIN="1.98.1"
# Use the linkers provided by the crossbuild-essential-* packages for cross-compiling.
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER="x86_64-linux-gnu-gcc"
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER="aarch64-linux-gnu-gcc"

# Install dependencies
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    <<EOF
# See https://github.com/kornelski/cargo-deb#cross-compilation for more details on the required packages.
packages=(pkg-config build-essential)
host_arch="$(dpkg --print-architecture)"

for arch in $_DEBIAN_ARCHES; do
    if [[ "$arch" != "$host_arch" ]]; then
        dpkg --add-architecture $arch
        packages+=("crossbuild-essential-$arch")
    fi
done

apt update
apt install -y ${packages[*]}
EOF

RUN --mount=type=cache,target=/usr/local/cargo/registry \
    <<EOF
host_triple="$(rustc -vV | awk '/^host/ { print $2 }')"
for triple in $_RUST_TARGETS; do
    if [[ "$triple" != "$host_triple" ]]; then
        rustup target add $triple
    fi
done

cargo install cargo-deb
EOF

COPY ./build.sh build.sh
COPY ./Dockerfile Dockerfile
