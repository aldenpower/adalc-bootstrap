#!/usr/bin/env bash

set -euo pipefail

trap "Failed at line $LINENO" ERR

cat <<"EOF"

-----------------------------------------
     .         _       _
    / \     __| | __ _| | ___
   / ^ \   / _` |/ _` | |/ __|
  /  _  \ | (_| | (_| | | (__
 /  | |~ \ \__,_|\__,_|_|\___|
/.-'   '-.\
Aldenpower dwn Arch Linux Configuration
-----------------------------------------
EOF

ROOT_DIR="$(dirname "$(realpath "$0")")"


source "$ROOT_DIR/scripts/log.sh"
source "$ROOT_DIR/scripts/paths.sh"
source "$ROOT_DIR/scripts/pkg.sh"

require_sudo() {
  if [[ $EUID -eq 0 ]]; then
    SUDO=""
  else
    sudo -v || exit 1
    SUDO="sudo"
  fi
}

enable_pacman_option() {
  local opt="$1"
  $SUDO sed -i "s/^#${opt}/${opt}/" /etc/pacman.conf
}

FLAG_INSTALL=0

while getopts ":ih" opt; do
  case "$opt" in
    i) FLAG_INSTALL=1 ;;
    h)
      echo -ne "Usage: $0 [options]\n-i   Install system\n-h   Show help\n"
      exit 0
      ;;
    *)
      echo -ne "Usage: $0 [options]\n-i   Install system\n-h   Show help\n"
      exit 1
      ;;
  esac
done


 # Default behavior
[[ $OPTIND -eq 1 ]] && FLAG_INSTALL=1

require_sudo

if [ ${FLAG_INSTALL} -eq 1 ]; then
  if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.bkp ]; then
      log_info "PACMAN modify :: customizing"

      $SUDO cp /etc/pacman.conf /etc/pacman.conf.bkp

      enable_pacman_option Color
      enable_pacman_option VerbosePkgLists

      log_info "PACMAN update :: packages"
      $SUDO pacman -Syy > /dev/null 2>&1
      $SUDO pacman -Fy > /dev/null 2>&1
  else
      log_info "PACMAN :: already configured"
  fi

  # aur helper
  if [ ! -d "/tmp/yay" ]; then
    log_info "AUR HELPER install :: yay"
    git clone https://aur.archlinux.org/yay.git /tmp/yay > /dev/null 2>&1
  fi
  pkg_installed yay || makepkg --dir /tmp/yay -si --noconfirm > /dev/null 2>&1

  log_info "INSTALL packages"

  tmpfile="$(mktemp)"
	sed '/^[[:space:]]*#/d' "$ROOT_DIR/config/packages/default.csv" > "$tmpfile"

	n=0

  while IFS= read -r line; do
	  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

	  tag="${line%%,*}"
	  rest="${line#*,}"

	  program="${rest%%,*}"
	  comment="${rest#*,}"

	  comment="${comment#\"}"
	  comment="${comment%\"}"

    log_info "INSTALLING $program - $comment"
	  case "$tag" in
	  	y)
        pkg_installed "$program" || yay --noconfirm --needed -S "$program" > /dev/null 2>&1
        ;;
	  	*)
	  		pkg_installed "$program" || $SUDO pacman --noconfirm --needed -S "$program" > /dev/null 2>&1
	  		;;
	  esac
  done < "$tmpfile"

	rm -f "$tmpfile"


  log_info "Create adalc sources"
  mkdir -p "$XDG_CONFIG_HOME/adalc"
  cp -r $ROOT_DIR/config/* "$XDG_CONFIG_HOME/adalc/"

  log_info "Building suckless tools"
  sudo make -C "$ROOT_DIR" all > /dev/null 2>&1

  log_info "Installing Xorg configuration"

  mkdir -p "$HOME"

  install -m 755 "$ROOT_DIR/config/xorg/xinitrc"    "$HOME/.xinitrc"
  install -m 644 "$ROOT_DIR/config/xorg/xprofile"   "$HOME/.xprofile"
  install -m 644 "$ROOT_DIR/config/xorg/Xresources" "$HOME/.Xresources"

  log_info "Configure zshell..."
  install -m 644 "$ROOT_DIR/config/shell/zsh/zshenv" "$HOME/.zshenv"

  log_info "Set shell"
  current_shell="$(getent passwd "$USER" | cut -d: -f7)"
  if [[ "$current_shell" != "/usr/bin/zsh" ]]; then
    chsh -s /usr/bin/zsh
  fi

  log_info "Installing alacritty and tmux config..."
  install -m 644 "$ROOT_DIR/config/alacritty/alacritty.toml" "$HOME/.alacritty.toml"
  install -m 644 "$ROOT_DIR/config/tmux/tmux.conf" "$HOME/.tmux.conf"

  # Create mpd dir
  mkdir -p "$HOME/.mpd"

  $SUDO systemctl enable ly@tty1.service
fi
