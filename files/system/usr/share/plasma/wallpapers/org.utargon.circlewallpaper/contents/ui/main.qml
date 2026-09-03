import QtQuick
import QtQuick.Effects
import org.kde.plasma.plasmoid

WallpaperItem {
    id: root

    readonly property string configuredImage: wallpaper.configuration.Image || ""

    function cleanPath(urlStr) {
        if (!urlStr) return "";
        var s = urlStr.toString();
        if (s.indexOf("file://") === 0) {
            return s;
        }
        return "file://" + s;
    }

    property string targetSource: cleanPath(configuredImage)
    property real animProgress: 0.0
    property bool isAnimating: false

    // Livello di base: visualizza stabilmente lo sfondo attivo
    Image {
        id: baseImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        source: root.targetSource
    }

    // Livello superiore: nuovo sfondo mascherato dal cerchio che si apre
    Item {
        id: overlayContainer
        anchors.fill: parent
        visible: root.isAnimating

        Image {
            id: newImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            visible: false
        }

        Item {
            id: circleMask
            anchors.fill: parent
            visible: false
            layer.enabled: true

            Rectangle {
                id: maskCircle
                anchors.centerIn: parent
                readonly property real maxRadius: Math.sqrt(root.width * root.width + root.height * root.height)
                width: maxRadius * root.animProgress * 2
                height: width
                radius: width / 2
                color: "black"
            }
        }

        MultiEffect {
            anchors.fill: parent
            source: newImage
            maskEnabled: true
            maskSource: circleMask
        }
    }

    // Animazione di apertura circolare (Circle Grow / Wipe)
    NumberAnimation {
        id: growAnimation
        target: root
        property: "animProgress"
        from: 0.0
        to: 1.0
        duration: 1400
        easing.type: Easing.OutCubic

        onFinished: {
            baseImage.source = newImage.source;
            root.isAnimating = false;
            root.animProgress = 0.0;
        }
    }

    onTargetSourceChanged: {
        if (!targetSource) return;

        if (baseImage.source.toString() === "" || baseImage.source.toString() === targetSource) {
            baseImage.source = targetSource;
            return;
        }

        newImage.source = targetSource;
        root.animProgress = 0.0;
        root.isAnimating = true;
        growAnimation.restart();
    }
}

