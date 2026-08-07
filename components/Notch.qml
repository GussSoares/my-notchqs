import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../modules"
import "../services"

Rectangle {
    id: notch

    property string activeView: "default"
    signal setExpanded(bool value)

    width: (mainLoader.item ? mainLoader.item.implicitWidth : 0) + 24
    height: 36
    radius: 18
    color: "#1a1b26"

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    // HoverHandler {
    //     id: hoverHandler
    //     onHoveredChanged: {
    //         if (hovered) {
    //             notch.activeView = "monitor"
    //         } else {
    //             notch.activeView = "default"
    //         }
    //     }
    // }

    Timer {
        id: restoreTimer
        interval: 2500
        repeat: false
        onTriggered: notch.activeView = "default"
    }

    Connections {
        target: VolumeController

        function onVolumeTriggered() {
            notch.activeView = "volume"
            restoreTimer.restart()
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                notch.activeView = "monitor"
            } else if (wheel.angleDelta.y < 0) {
                notch.activeView = "clock"
            }
        }
    }

    Loader {
        id: mainLoader
        anchors.centerIn: parent
        // sourceComponent: notch.activeView === "volume" ? volumeComponent : monitorComponent
        sourceComponent: {
            switch (notch.activeView) {
                case "volume": return volumeComponent;
                case "clock": return clockComponent;
                case "monitor": return monitorComponent;
                default: return clockComponent;
            }
        }
    }

    // Componente do Clock
    Component {
        id: clockComponent

        Clock {
            opacity: 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Component.onCompleted: opacity = 1
        }
    }

    // Componente do Monitor
    Component {
        id: monitorComponent

        Monitor {
            opacity: 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Component.onCompleted: opacity = 1
        }
    }

    // Componente do Volume
    Component {
        id: volumeComponent

        Volume {
            opacity: 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Component.onCompleted: opacity = 1
        }
    }
}