実際に使用する際は以下の記事も参考にしてください。

https://aktars-blog.com/blog/0011/

https://aktars-blog.com/blog/0012/

https://aktars-blog.com/blog/0013/

**また、chezmoi で展開すると既存の同名ファイルが上書きされるので、試す際は事前にバックアップを取ることを強く推奨します。**

# dotfiles

`chezmoi` を使って、以下の設定を管理しています。

- zsh
- sheldon
- starship
- git
- AstroNvim
- 一部の補助ツール (`lazygit`, `zsh-autocomplete`, `nvim`)
- ターミナル用フォントとして Firple

対象環境:

- WSL 上の Ubuntu
- 通常の Ubuntu

---

## 想定している初期状態

この README は、以下のような環境を想定しています。

- ほぼ素の Ubuntu
- または WSL を有効化した直後の Ubuntu
- dotfiles はまだ展開していない

---

## 全体の流れ

1. 基本パッケージを入れる
2. Rust / cargo を入れる
3. sheldon を入れる
4. starship を入れる
5. chezmoi を入れる
6. dotfiles を展開する
7. zsh をデフォルトシェルにする
8. nvm を入れる
9. Node.js を入れる
10. Neovim 用の Node provider を入れる
11. chezmoi をもう一度 apply する
12. AstroNvim を起動する
13. フォントを Firple にする

詳細なセットアップスクリプトの説明は [docs/setup-scripts.md](docs/setup-scripts.md) を参照してください。

---

## 1. 基本パッケージを入れる

```bash
sudo apt update
sudo apt install -y \
    curl \
    git \
    unzip \
    tar \
    build-essential \
    pkg-config \
    libssl-dev \
    ripgrep \
    fd-find \
    sqlite3 \
    xclip \
    python3 \
    python3-pip \
    python3-pynvim \
    zsh
```

---

## 2. Rust / cargo を入れる

`sheldon` のインストールに `cargo` を使うため、Rust を入れます。

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

インストール後、現在のシェルに cargo の PATH を反映します。

```bash
. "$HOME/.cargo/env"
```

確認:

```bash
cargo --version
rustc --version
```

---

## 3. sheldon を入れる

`sheldon` は zsh plugin manager として使用します。

```bash
cargo install sheldon
```

確認:

```bash
sheldon --version
```

この dotfiles では、主に以下の設定ファイルを管理します。

```text
~/.config/sheldon/plugins.toml
```

`sheldon` の設定ファイルは、dotfiles 展開後に chezmoi から配置されます。

---

## 4. starship を入れる

`starship` は zsh のプロンプトとして使用します。

```bash
curl -sS https://starship.rs/install.sh | sh
```

確認:

```bash
starship --version
```

この dotfiles では、主に以下の設定ファイルを管理します。

```text
~/.config/starship.toml
```

`starship.toml` では、最低限次のような設定を管理します。

```toml
# ~/.config/starship.toml

add_newline = false

[directory]
truncation_length = 3
truncate_to_repo = true

[cmd_duration]
min_time = 1000
format = "took [$duration]($style) "

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold blue)"
```

---

## 5. chezmoi を入れる

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

この構成では `~/bin/chezmoi` に入る想定です。

確認:

```bash
~/bin/chezmoi --version
```

---

## 6. dotfiles を展開する

SSH で GitHub にアクセスできる状態で、以下を実行します。

```bash
~/bin/chezmoi init git@github.com:<YOUR_GITHUB_NAME>/dotfiles.git
~/bin/chezmoi apply
```

この時点で、以下の設定ファイルが展開されます。

- `~/.zshrc`
- `~/.zsh_functions`
- `~/.gitconfig`
- `~/.config/sheldon/plugins.toml`
- `~/.config/starship.toml`
- `~/.config/nvim`

また、`.chezmoiscripts` 配下の `run_once_` スクリプトも実行されます。

ただし、この時点ではまだ `nvm` と `node` が入っていないため、Node を前提にする処理は後で整えます。

---

## 7. zsh をデフォルトシェルにする

```bash
chsh -s "$(which zsh)"
```

その後、ターミナルを開き直してください。

すぐ試したい場合は、その場で `zsh` を起動しても構いません。

```bash
zsh
```

---

## 8. nvm を入れる

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
source ~/.zshrc
```

確認:

```bash
command -v nvm
nvm --version
```

---

## 9. Node.js を入れる

```bash
nvm install --lts
nvm alias default 'lts/*'
```

確認:

```bash
node --version
npm --version
```

---

## 10. Neovim 用の Node provider を入れる

```bash
npm install -g neovim
```

---

## 11. chezmoi をもう一度 apply する

`nvm` と `node` が入った状態でもう一度適用します。

```bash
~/bin/chezmoi apply
```

これにより、必要なスクリプトが改めて実行され、補助ツールのセットアップが揃います。

確認したいコマンド:

```bash
which -a nvim
nvim --version
lazygit --version
sheldon --version
starship --version
```

`nvim` は `~/bin/nvim` が使われていれば OK です。

もし `/usr/bin/nvim` が先に出てきたら、apt 版 Neovim が混ざっている可能性があります。
その場合は削除してください。

```bash
sudo apt remove -y neovim
hash -r
which -a nvim
```

---

## 12. AstroNvim を起動する

```bash
nvim
```

初回起動時には plugin のインストールが走るため、少し時間がかかることがあります。

必要なら health check を確認します。

```vim
:checkhealth
```

---

## 13. フォントを Firple にする

AstroNvim や starship のアイコンを正しく表示するには、Nerd Fonts 対応フォントが必要です。

この dotfiles では、ターミナルフォントとして **Firple** を使う想定です。

Firple は、Fira Code と IBM Plex Sans JP を合成した日本語対応のプログラミング向けフォントです。

特徴:

- 日本語対応
- 等幅フォント
- 半角文字と全角文字の幅が 1:2
- リガチャ対応
- Nerd Fonts 対応
- Regular / Bold / Italic 対応
- Firple / Firple Slim のファミリーあり

---

### WSL の場合

WSL では **Windows 側** に Firple を入れてください。

手順:

1. Firple の GitHub Releases から最新版の zip をダウンロードする
2. zip を展開する
3. `.ttf` または `.otf` ファイルを選択する
4. 右クリックして「インストール」または「すべてのユーザーに対してインストール」
5. Windows Terminal を開く
6. WSL プロファイルのフォントを `Firple` または `Firple Slim` に変更する

Windows Terminal の設定例:

```json
{
    "profiles": {
        "list": [
            {
                "name": "Ubuntu",
                "font": {
                    "face": "Firple"
                }
            }
        ]
    }
}
```

1 行の表示文字数を多めに取りたい場合は、`Firple Slim` を使ってもよいです。

```json
{
    "profiles": {
        "list": [
            {
                "name": "Ubuntu",
                "font": {
                    "face": "Firple Slim"
                }
            }
        ]
    }
}
```

---

### 通常の Ubuntu の場合

Ubuntu 側に Firple を入れて、使っているターミナルのフォント設定を変更してください。

例:

```bash
mkdir -p ~/.local/share/fonts/Firple
```

Firple の zip をダウンロードして展開したあと、`.ttf` または `.otf` を以下に配置します。

```bash
cp path/to/Firple/*.ttf ~/.local/share/fonts/Firple/
```

フォントキャッシュを更新します。

```bash
fc-cache -fv
```

認識されているか確認します。

```bash
fc-list | grep -i Firple
```

その後、GNOME Terminal や Tilix など、使用しているターミナルの設定からフォントを `Firple` または `Firple Slim` に変更してください。

---

## セットアップ後の確認

以下が通れば、だいたいセットアップ完了です。

```bash
zsh --version
git --version
cargo --version
sheldon --version
starship --version
node --version
npm --version
python3 --version
nvim --version
lazygit --version
```

Neovim 内では:

```vim
:checkhealth
```

フォント確認:

```bash
fc-list | grep -i Firple
```

WSL の場合、`fc-list` に出るかどうかではなく、Windows Terminal 側で Firple を選択できていれば OK です。

---

## 更新方法

設定を変更したら、基本的には以下の流れで反映します。

```bash
chezmoi diff
chezmoi git -- status
chezmoi git -- add .
chezmoi git -- commit -m "設定を更新"
chezmoi git -- push
```

別の環境で反映する場合:

```bash
chezmoi update
```

または:

```bash
chezmoi apply
```
