#!/usr/bin/env bash
# Generato da Matugen: applica la variante Fluent più vicina al wallpaper
# e la notifica alle app già aperte (Dolphin, plasmashell, GTK)

COLOR="{{closest_color}}"

case "$COLOR" in
    purple|pink|red|orange|yellow|green|teal|grey) THEME="Fluent-${COLOR}-dark" ;;
    *) THEME="Fluent-dark" ;;
esac

# 1. KDE: plasma-changeicons scrive kdeglobals, cancella la cache e invia
#    iconChanged su D-Bus -> le app aperte ricaricano le icone subito.
#    NON scrivere prima kdeglobals: se il tema risulta già impostato, il tool
#    non invia la notifica.
if [[ -x /usr/libexec/plasma-changeicons ]]; then
    /usr/libexec/plasma-changeicons "$THEME"
else
    # Ripiego manuale: stesso effetto del tool
    kwriteconfig6 --file kdeglobals --group Icons --key Theme "$THEME"
    rm -f "$HOME/.cache/icon-cache.kcache"
    for group in 0 1 2 3 4 5; do   # tutti i gruppi di KIconLoader
        dbus-send --session --type=signal /KIconLoader \
            org.kde.KIconLoader.iconChanged "int32:$group"
    done
fi

# 2. App GTK (si aggiornano da sole quando cambia la chiave)
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface icon-theme "$THEME" 2>/dev/null || true
fi