# install-plasmoids

Installa plasmoid QML-only in `/usr/share/plasma/plasmoids/<id-plugin>`, scaricando
l'**ultima release** pubblicata su GitHub a ogni build dell'immagine (nessun pin:
la versione cambia quando upstream pubblica e l'immagine si rebuilda).

Al momento installa: Minimalist Animated Weather (`Samy879/minimalist-animated-weather`).

Per aggiungerne un altro (solo QML, senza parti C++ da compilare): aggiungi
`"proprietario/repo"` all'array `REPOS` nello script. La cartella di destinazione
viene ricavata dal `KPlugin.Id` del `metadata.json`, quindi non serve configurarla.

Lo skel (`plasma-org.kde.plasma.desktop-appletsrc`) referenzia i widget per ID plugin:
finché l'ID non cambia upstream, l'integrazione nel pannello resta valida.
