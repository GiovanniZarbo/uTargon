#!/usr/bin/env bash
set -xe
chmod +x /usr/bin/rofi-wallpaper
chmod +x /usr/bin/utargon-first-setup

# Se qdbus non esiste ma esiste qdbus6, crea symlink
if [[ -f /usr/bin/qdbus6 && ! -f /usr/bin/qdbus ]]; then
    ln -sf /usr/bin/qdbus6 /usr/bin/qdbus
fi


