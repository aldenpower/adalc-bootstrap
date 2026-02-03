#!/bin/bash

if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

$SUDO pacman -Syu --noconfirm --needed git

ADALC_REPO="${ADALC_REPO:-aldenpower/adalc-bootstrap}"

echo -e "\nCloning Repo from: https://github.com/${ADACL_REPO}.git"
rm -rf ~/.local/share/adalc/
git clone "https://github.com/${ADALC_REPO}.git" ~/.local/share/adalc >/dev/null

ADALC_REF="${ADALC_REF:-main}"
cd ~/.local/share/adalc
git fetch origin "${ADALC_REF}" && git checkout "${ADALC_REF}"
cd -

echo -e "\nInstalling..."
source ~/.local/share/adalc/install.sh
