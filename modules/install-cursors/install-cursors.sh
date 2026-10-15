#!/usr/bin/env bash
set -euo pipefail

# Pin a commit specifico per build riproducibili (stato upstream del 2021-11-27,
# repository fermo da allora: il pin è di fatto definitivo).
# Per aggiornare il tema: sostituire lo SHA con il commit desiderato.
ARCDUSK_SHA="a6fa6ff1ff713eb5d76f3625428ef1aa23c980d5"

# 1. Scarica il tema cursori ArcDusk dal repository GitHub
#    (contiene già la build compilata dentro dist/, non serve compilare nulla)
mkdir -p /tmp/cursori_temp
curl -Lo /tmp/cursori_temp/ArcDusk-Cursors.tar.gz \
  "https://codeload.github.com/yeyushengfan258/ArcDusk-Cursors/tar.gz/${ARCDUSK_SHA}"

# 2. Estrae l'archivio e rileva la cartella sorgente (il nome dipende dal ref scaricato)
tar -xf /tmp/cursori_temp/ArcDusk-Cursors.tar.gz -C /tmp/cursori_temp
SOURCE_DIR="$(tar -tzf /tmp/cursori_temp/ArcDusk-Cursors.tar.gz | head -n1 | cut -d/ -f1)"

# 3. Usa lo script di installazione ufficiale
cd "/tmp/cursori_temp/${SOURCE_DIR}"
./install.sh

# 4. Imposta ArcDusk-cursors come default di sistema (/usr/share/icons/default/index.theme)
mkdir -p /usr/share/icons/default
cat << 'EOF' > /usr/share/icons/default/index.theme
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=ArcDusk-cursors
EOF

# 5. Pulizia
rm -rf /tmp/cursori_temp
