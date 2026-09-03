#!/usr/bin/env bash
set -xe

# 1. Scarica il tema icone Fluent direttamente dal repository GitHub
mkdir -p /tmp/icone_temp
curl -Lo /tmp/icone_temp/Fluent-icon-theme.tar.gz \
  https://codeload.github.com/vinceliuice/Fluent-icon-theme/tar.gz/refs/heads/master

# 2. Estrae l'archivio
tar -xf /tmp/icone_temp/Fluent-icon-theme.tar.gz -C /tmp/icone_temp

# 3. Usa lo script di installazione ufficiale del tema per generare
#    la variante "purple" (crea Fluent-purple, Fluent-purple-light, Fluent-purple-dark)
#    direttamente nella cartella di sistema delle icone
cd /tmp/icone_temp/Fluent-icon-theme-master
./install.sh -d /usr/share/icons -n Fluent purple

# 4. Pulisce la cartella temporanea
rm -rf /tmp/icone_temp
