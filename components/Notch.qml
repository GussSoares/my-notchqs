import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import "../components"
import "../modules"
import "../services"

import "../components/Notch" as Notch
import "../"

Rectangle {
    id: notch

    property var focusedScreen

    property string activeView: "clock"
    signal setExpanded(bool value)

    width: (mainLoader.item ? mainLoader.item.width : 0)
    height: (mainLoader.item ? mainLoader.item.height : 0)
    radius: 18
    color: Theme.background

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

    Timer {
        id: notificationTimer
        interval: 5000
        repeat: false
        onTriggered: notch.activeView = "default"
    }

    Connections {
        target: VolumeController
        enabled: notch.focusedScreen

        function onAudioVolumeTriggered() {
            notch.activeView = "volume";
            restoreTimer.restart();
        }
    }

    Connections {
        target: BrightnessController
        enabled: notch.focusedScreen

        function onBrightnessChanged(value) {
            notch.activeView = "brightness";
            restoreTimer.restart();
        }
    }

    Connections {
        target: NotificationController
        enabled: notch.focusedScreen

        function onNewNotification(value) {
            notch.activeView = "notification";
            notificationTimer.restart();
        }
    }

    Connections {
        target: IpcController
        enabled: notch.focusedScreen

        function onTriggerNotchExpanded(value) {
            notch.activeView = "controlCenter";
            restoreTimer.restart();
        }
        function onTriggerPowerMenu(value) {
            notch.activeView = "powerMenu";
        }
    }

    Connections {
        target: MprisController
        enabled: notch.focusedScreen

        function onIsPlayingChanged() {
            if (MprisController.isPlaying) {
                notch.activeView = "musicNotification";
                restoreTimer.restart();
            }
        }
    }

    Loader {
        id: mainLoader
        anchors.centerIn: parent

        width: (item ? item.implicitWidth : 0) + 24
        height: (item ? item.implicitHeight : 0) + 13

        sourceComponent: {
            switch (notch.activeView) {
            case "clock":
                return clockComponent;
            case "volume":
                return volumeComponent;
            case "monitor":
                return monitorComponent;
            case "brightness":
                return brightnessComponent;
            case "notification":
                return notificationComponent;
            case "expandedNotch":
                return expandedComponent;
            case "powerMenu":
                return powerMenuComponent;
            case "musicNotification":
                return musicNotificationComponent;
            case "controlCenter":
                return controlCenterComponent;
            default:
                return clockComponent;
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onWheel: wheel => {
                if (wheel.angleDelta.y > 0) {
                    notch.activeView = "expandedNotch";
                } else if (wheel.angleDelta.y < 0) {
                    notch.activeView = "controlCenter";
                }
            }

            onEntered: {
                notch.activeView = 'expandedNotch'
            }
            onExited: {
                notch.activeView = 'clock'
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: notch.activeView = "controlCenter";
        }
    }

    // Componente do Clock
    Component {
        id: clockComponent

        Notch.MainNotch {
            additionalPadding: 40

            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    // Componente do Monitor
    Component {
        id: monitorComponent

        Monitor {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    // Componente do Volume
    Component {
        id: volumeComponent

        Volume {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    // Componente de Brilho
    Component {
        id: brightnessComponent

        Brightness {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    Component {
        id: notificationComponent

        NotificationPopup {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    Component {
        id: expandedComponent

        NotchExpanded {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    Component {
        id: powerMenuComponent

        PowerMenu {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    Component {
        id: musicNotificationComponent

        MusicNotification {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }

    Component {
        id: controlCenterComponent

        ControlCenter {
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            Component.onCompleted: opacity = 1
        }
    }
}
