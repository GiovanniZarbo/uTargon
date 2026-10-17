#!/usr/bin/env bash
set -euo pipefail

# Plasmoid QML-only da installare. Nessun pin di versione: ogni build
# dell'immagine scarica l'ultima release pubblicata su GitHub.
REPOS=(
    "Samy879/minimalist-animated-weather"
)

WORK=/tmp/plasmoid_temp

for REPO in "${REPOS[@]}"; do
    rm -rf "$WORK"
    mkdir -p "$WORK"

    # 1. Tag dell'ultima release dall'API di GitHub (senza jq)
    TAG="$(curl -sL "https://api.github.com/repos/${REPO}/releases/latest" | grep -oE '"tag_name": *"[^"]+"' | head -1 | cut -d'"' -f4)"
    if [[ -z "$TAG" ]]; then
        echo "ERRORE: impossibile leggere l'ultima release di ${REPO}" >&2
        exit 1
    fi

    # 2. Tarball sorgente del tag: sempre disponibile, richiede solo curl+tar
    #    (i plasmoid QML-only non hanno bisogno di build)
    curl -Lo "$WORK/src.tar.gz" "https://codeload.github.com/${REPO}/tar.gz/refs/tags/${TAG}"

    # 3. Rileva la cartella sorgente (il nome dipende dal tag): elencare TUTTO
    #    l'archivio prima di prendere la prima voce, una pipeline `tar | head`
    #    fa morire tar di SIGPIPE e con pipefail fallirebbe il modulo
    LISTING="$(tar -tzf "$WORK/src.tar.gz")"
    SOURCE_DIR="${LISTING%%/*}"
    tar -xf "$WORK/src.tar.gz" -C "$WORK"
    SRC="$WORK/$SOURCE_DIR"

    # 4. La cartella di destinazione deve chiamarsi esattamente come l'ID
    #    plugin dichiarato nel metadata.json, altrimenti Plasma non lo trova
    ID="$(grep -oE '"Id": *"[^"]+"' "$SRC/metadata.json" | head -1 | cut -d'"' -f4)"
    if [[ -z "$ID" ]]; then
        echo "ERRORE: ${REPO} senza KPlugin.Id nel metadata.json" >&2
        exit 1
    fi

    # 5. Copia in /usr/share/plasma/plasmoids/<id> senza i file di repo
    DEST="/usr/share/plasma/plasmoids/$ID"
    mkdir -p "$DEST"
    cp -r "$SRC/contents" "$SRC/metadata.json" "$DEST/"
    [[ -d "$SRC/translate" ]] && cp -r "$SRC/translate" "$DEST/"
    [[ -f "$SRC/LICENSE" ]] && cp "$SRC/LICENSE" "$DEST/"

    echo "Installato plasmoid: $ID (release $TAG)"
done

rm -rf "$WORK"
