import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../modules"
import "../services"

Rectangle {
    id: notch

    property string activeView: "clock"

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

    Loader {
        id: mainLoader
        anchors.centerIn: parent
        sourceComponent: notch.activeView === "volume" ? volumeComponent : clockComponent
    }

    // Componente do Relógio
    Component {
        id: clockComponent

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