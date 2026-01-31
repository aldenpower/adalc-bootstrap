# /etc/zsh/zshrc: system-wide .zshrc file for zsh(1).
#
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

# Zsh ties the PATH variable to a path array. This allows
# you to manipulate PATH by simply modifying the path array.
# See A User's Guide to the Z-Shell for details.
typeset -U path PATH

path=(~/.local/bin
      ~/.config/adalc/scripts
      $path)

# source aliases
[[ -r "$ZDOTDIR/.aliases" ]] && . "$ZDOTDIR/.aliases"

# Set up the prompt
autoload -Uz promptinit; promptinit

# Check if prompt_config.zsh exists and source it if it does
if [ -f "$ZDOTDIR/prompt.zsh" ]; then
  source "$ZDOTDIR/prompt.zsh"
else
  prompt bart blue
fi

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
#bindkey -e
bindkey -v

# Enebla cntrl search
bindkey '^R' history-incremental-search-backward

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# Functions
fpath+=("$HOME/.config/adalc/shell/zsh/functions" "$fpath[@]")
autoload -Uz y hellozsh
