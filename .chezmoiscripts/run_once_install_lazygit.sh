#!/usr/bin/env bash
set -eu

if command -v lazygit >/dev/null 2>&1; then
    exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install lazygit" >&2
    exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
    echo "tar is required to install lazygit" >&2
    exit 1
fi

mkdir -p "$HOME/bin"

VERSION="$(
    curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep -Po '"tag_name":\s*"v\K[^"]+'
)"

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1
        ;;
esac

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

curl -fLo "$TMPDIR/lazygit.tar.gz" \
    "https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_${ARCH}.tar.gz"

tar -xzf "$TMPDIR/lazygit.tar.gz" -C "$TMPDIR" lazygit
install -m 755 "$TMPDIR/lazygit" "$HOME/bin/lazygit"
