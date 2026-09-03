#!/usr/bin/env bash

# Script generato da Matugen per impostare il tema icone Fluent
# con la variante di colore più vicina al wallpaper corrente

COLOR="{{ closest_color }}"

case "$COLOR" in
    blue)
        THEME="Fluent-dark"
        ;;
    purple|pink|red|orange|yellow|green|teal|grey)
        THEME="Fluent-${COLOR}-dark"
        ;;
    *)
        THEME="Fluent-dark"
        ;;
esac

# 1. Imposta il tema icone in KDE Plasma (Dolphin, Desktop, App KDE)
if command -v kwriteconfig6 &>/dev/null; then
    kwriteconfig6 --file kdeglobals --group Icons --key Theme "$THEME"
fi

# 2. Imposta il tema icone per le applicazioni GTK
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface icon-theme "$THEME" 2>/dev/null || true
fi

# 3. Pulisce la cache icone per consentire il reload immediato
rm -f "$HOME/.cache/icon-cache.kcache" 2>/dev/null || true

