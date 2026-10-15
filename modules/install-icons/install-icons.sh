#!/usr/bin/env bash
set -euo pipefail

# Pin a commit specifico per build riproducibili (stato upstream del 2026-08-30).
# Per aggiornare il tema: sostituire lo SHA con il commit desiderato.
FLUENT_SHA="c8a244f571ef8fb47812bdc9dbce76546cedce69"

# 1. Scarica il tema icone Fluent dal repository GitHub
mkdir -p /tmp/icone_temp
curl -Lo /tmp/icone_temp/Fluent-icon-theme.tar.gz \
  "https://codeload.github.com/vinceliuice/Fluent-icon-theme/tar.gz/${FLUENT_SHA}"

# 2. Rileva la cartella sorgente (il nome dipende dal ref scaricato: con uno SHA
#    cambia) elencando TUTTO l'archivio prima di prendere la prima voce: una
#    pipeline `tar | head` fa morire tar di SIGPIPE e, con pipefail, fallirebbe
#    il modulo anche con un archivio valido
LISTING="$(tar -tzf /tmp/icone_temp/Fluent-icon-theme.tar.gz)"
SOURCE_DIR="${LISTING%%/*}"

# 3. Estrae l'archivio
tar -xf /tmp/icone_temp/Fluent-icon-theme.tar.gz -C /tmp/icone_temp

# 4. Usa lo script di installazione ufficiale del tema per generare
#    tutte le varianti colore (blue, purple, pink, red, orange, yellow, green, teal, grey)
cd "/tmp/icone_temp/${SOURCE_DIR}"
./install.sh -a -d /usr/share/icons -n Fluent

# 5. Pulizia
cd /
rm -rf /tmp/icone_temp
