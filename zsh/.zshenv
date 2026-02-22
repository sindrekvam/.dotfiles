
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export EDITOR="nvim"
export VISUAL="nvim"

# zsh History
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

# Allow italics in terminal
export TERM="xterm-256color"

# Add to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

# Golang
export PATH="$PATH:/usr/local/go/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/bin"
. "$HOME/.cargo/env"

# opencode
export PATH="$PATH:$HOME/.opencode/bin"
