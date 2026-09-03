#!/usr/bin/env bash
set -xe

# 1. Scarica il tema cursori ArcDusk direttamente dal repository GitHub
#    (contiene già la build compilata dentro dist/, non serve compilare nulla)
mkdir -p /tmp/cursori_temp
curl -Lo /tmp/cursori_temp/ArcDusk-Cursors.tar.gz \
  https://codeload.github.com/yeyushengfan258/ArcDusk-Cursors/tar.gz/refs/heads/main

# 2. Estrae l'archivio
tar -xf /tmp/cursori_temp/ArcDusk-Cursors.tar.gz -C /tmp/cursori_temp

# 3. Installa i cursori già compilati nella cartella di sistema
mkdir -p /usr/share/icons
cp -r /tmp/cursori_temp/ArcDusk-Cursors-main/dist/* /usr/share/icons/

# 4. Pulisce la cartella temporanea
rm -rf /tmp/cursori_temp
