# setup scripts

このドキュメントでは、`.chezmoiscripts` 配下のスクリプトが何をしているかを説明します。

---

## zsh plugins について

zsh の plugin は `sheldon` で管理します。

現在は以下を対象にしています。

- `zsh-completions`
- `zsh-autosuggestions`
- `fast-syntax-highlighting`

plugin の定義は以下のファイルで管理します。

```text
~/.config/sheldon/plugins.toml
```

そのため、`.chezmoiscripts` では zsh plugin を直接 clone しません。

plugin を更新したい場合は、以下を実行します。

```bash
sheldon lock --update
```

反映する場合は zsh を再起動します。

```bash
exec zsh
```

---

## run_once_install_lazygit.sh

### 目的

`lazygit` を GitHub Releases のバイナリからインストールします。

### 処理内容

- すでに `lazygit` が使えるなら何もしない
- `curl`, `tar`, `install` が使えるか確認する
- GitHub API から最新バージョンを取得する
- アーキテクチャ (`x86_64`, `arm64`) を判定する
- tar.gz をダウンロードする
- `~/bin/lazygit` に配置する

### 補足

- `apt` や PPA には依存しません
- `~/bin` を PATH に通している前提です

---

## run_once_install_neovim.sh

### 目的

Neovim 本体をユーザー領域にインストールします。

### 処理内容

- `curl`, `tar`, `install` が使えるか確認する
- アーキテクチャを判定する
- GitHub Releases から Neovim の Linux バイナリを取得する
- `~/.local/opt` 配下に展開する
- `~/bin/nvim` に symlink を張る

### 補足

- `sudo` は使いません
- `/usr/bin/nvim` と衝突しにくいように、ユーザー領域へ入れています
- `~/bin/nvim` が優先されるように PATH を通してください

---

## run_once_ を使っている理由

これらのスクリプトは、`chezmoi apply` 時に **初回だけ実行** される想定です。

このため、

- 毎回同じダウンロード処理を繰り返さない
- 初期セットアップだけ自動化できる

という利点があります。

一方で、スクリプトを書き換えても、すでに実行済みの環境では自動再実行されません。  
更新処理まで自動化したい場合は、`run_onchange_` など別の構成を検討してください。
