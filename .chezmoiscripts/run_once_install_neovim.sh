#!/usr/bin/env bash
set -eu

if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install neovim" >&2
    exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
    echo "tar is required to install neovim" >&2
    exit 1
fi

if ! command -v install >/dev/null 2>&1; then
    echo "install command is required to install neovim" >&2
    exit 1
fi

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
esac

INSTALL_BASE="$HOME/.local/opt"
INSTALL_DIR="$INSTALL_BASE/nvim-linux-$ARCH"
BIN_DIR="$HOME/bin"
TARGET_BIN="$BIN_DIR/nvim"

mkdir -p "$INSTALL_BASE" "$BIN_DIR"

# すでに管理対象の nvim が入っていれば何もしない
if [ -x "$INSTALL_DIR/bin/nvim" ]; then
    ln -sfn "$INSTALL_DIR/bin/nvim" "$TARGET_BIN"
    exit 0
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

ARCHIVE="$TMPDIR/nvim-linux-$ARCH.tar.gz"
URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"

curl -fLo "$ARCHIVE" "$URL"

rm -rf "$INSTALL_DIR"
tar -xzf "$ARCHIVE" -C "$INSTALL_BASE"

ln -sfn "$INSTALL_DIR/bin/nvim" "$TARGET_BIN"
