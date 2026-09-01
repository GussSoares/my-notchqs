import Quickshell
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../"
import "../../services"

Rectangle {
    id: root
    width: 100
    height: 60
    color: 'transparent'
    
    property bool selected: false
    property var theme

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: ThemeController.applyTheme(theme.fileName)
    }

    HoverHandler {
        id: hoverHandler
    }

    Image {
        id: img
        anchors.fill: parent
        source: "file://" + ThemeController.thumbDir + "/" + theme.fileName + ".png"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: img.width
                height: img.height
                radius: 12
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: "transparent"
        border.color: hoverHandler.hovered ? Theme.accent : (root.selected ? Theme.accent : "transparent")
        border.width: 2

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }
    }
}
