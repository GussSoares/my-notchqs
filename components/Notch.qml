import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../components"
import "../modules"
import "../services"

Rectangle {
    id: notch

    property string activeView: "default"
    signal setExpanded(bool value)

    width: (mainLoader.item ? mainLoader.item.implicitWidth : 0) + 24
    height: (mainLoader.item ? mainLoader.item.implicitHeight : 0) + 13
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

        function onAudioVolumeTriggered() {
            notch.activeView = "volume"
            restoreTimer.restart()
        }
    }

    Connections {
        target: BrightnessController

        function onBrightnessChanged(value) {
            notch.activeView = "brightness"
            restoreTimer.restart()
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onWheel: (wheel) => {
            if (wheel.angleDelta.x < 0) {
                notch.activeView = "monitor"
            } else if (wheel.angleDelta.x > 0) {
                notch.activeView = "clock"
            } else if (wheel.angleDelta.y > 0) {
                notch.activeView = "expandedComponent"
            } else if (wheel.angleDelta.y < 0) {
                notch.activeView = "clock"
            }
        }

        // onEntered: {
        //     notch.activeView = "expandedComponent"
        // }
        // onExited: {
        //     notch.activeView = "clock"
        // }
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
                case "brightness": return brightnessComponent;
                case "expandedComponent": return expandedComponent
                default: return clockComponent;
            }
        }
    }

    // Componente do Clock
    Component {
        id: clockComponent

        RowLayout {
            spacing: 12

            MiniCava {}

            Battery {
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                Component.onCompleted: opacity = 1
            }

            // Clock {
            //     opacity: 0
            //     Behavior on opacity { NumberAnimation { duration: 200 } }
            //     Component.onCompleted: opacity = 1
            // }
            SystemClock {
                id: clock
                precision: SystemClock.Minutes
            }

            Text {
                id: root

                property string format: "hh:mm"

                text: Qt.formatDateTime(clock.date, root.format)
                color: "#7dcfff"
                font.pixelSize: 13
                font.bold: true
                Layout.alignment: Qt.AlignVCenter

            }

            VolumeIndicator {
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                Component.onCompleted: opacity = 1
            }

            MicIndicator {
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                Component.onCompleted: opacity = 1
            }
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

    // Componente de Brilho
    Component {
        id: brightnessComponent

        Brightness {
            opacity: 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Component.onCompleted: opacity = 1
        }
    }

    Component {
        id: expandedComponent

        NotchExpanded {
            opacity: 0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            Component.onCompleted: opacity = 1
        }
    }
}