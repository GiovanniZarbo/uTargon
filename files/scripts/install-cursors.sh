#!/usr/bin/env bash
set -xe

# 1. Scarica il tema cursori ArcDusk direttamente dal repository GitHub
#    (contiene già la build compilata dentro dist/, non serve compilare nulla)
mkdir -p /tmp/cursori_temp
curl -Lo /tmp/cursori_temp/ArcDusk-Cursors.tar.gz \
  https://codeload.github.com/yeyushengfan258/ArcDusk-Cursors/tar.gz/refs/heads/main

# 2. Estrae l'archivio
tar -xf /tmp/cursori_temp/ArcDusk-Cursors.tar.gz -C /tmp/cursori_temp

# 3. Usa lo script di installazione ufficiale
cd /tmp/cursori_temp/ArcDusk-Cursors-main
./install.sh

# 4. Imposta ArcDusk-cursors come default di sistema (/usr/share/icons/default/index.theme)
mkdir -p /usr/share/icons/default
cat << 'EOF' > /usr/share/icons/default/index.theme
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=ArcDusk-cursors
EOF

# 5. Pulisce la cartella temporanea
rm -rf /tmp/cursori_temp
