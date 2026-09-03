import QtQuick
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid

Item {
    id: configPage

    property alias cfg_Image: imageField.text

    QQC2.TextField {
        id: imageField
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        placeholderText: "Percorso immagine..."
        text: wallpaper.configuration.Image || ""
    }
}

