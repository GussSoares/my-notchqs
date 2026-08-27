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

    property int activeView: NavigationController.Views.Clock
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
        onTriggered: {
            if (notch.focusedScreen) {
                NavigationController.navigate(NavigationController.Views.Clock)
            } else {
                NavigationController.navigate(NavigationController.Views.Clock)
                notch.activeView = NavigationController.Views.Clock
            }
        }
    }

    Timer {
        id: notificationTimer
        interval: 5000
        repeat: false
        onTriggered: {
            if (notch.focusedScreen) {
                NavigationController.navigate(NavigationController.Views.Clock)
            } else {
                NavigationController.navigate(NavigationController.Views.Clock)
                notch.activeView = NavigationController.Views.Clock
            }
        }
    }

    Connections {
        target: NavigationController
        enabled: notch.focusedScreen

        function onCurrentViewChanged() {
            notch.activeView = NavigationController.currentView
        }
    }

    Connections {
        target: VolumeController
        enabled: notch.focusedScreen

        function onAudioVolumeTriggered() {
            if (activeView !== NavigationController.Views.ControlCenter) {
                NavigationController.navigate(NavigationController.Views.Volume)
                restoreTimer.restart();
            }
        }
    }

    Connections {
        target: BrightnessController
        enabled: notch.focusedScreen

        function onBrightnessChanged(value) {
            NavigationController.navigate(NavigationController.Views.Brightness)
            restoreTimer.restart();
        }
    }

    Connections {
        target: NotificationController
        enabled: notch.focusedScreen

        function onNewNotification(value) {
            NavigationController.navigate(NavigationController.Views.Notification)
            notificationTimer.restart();
        }
    }

    Connections {
        target: IpcController
        enabled: notch.focusedScreen

        function onTriggerNotchExpanded(value) {
            NavigationController.navigate(NavigationController.Views.ControlCenter)
            restoreTimer.restart();
        }
        function onTriggerPowerMenu(value) {
            NavigationController.navigate(NavigationController.Views.PowerMenu)
        }
    }

    Connections {
        target: MprisController
        enabled: notch.focusedScreen

        function onIsPlayingChanged() {
            if (MprisController.isPlaying) {
                NavigationController.navigate(NavigationController.Views.Music)
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
            case NavigationController.Views.Clock:
                return clockComponent;
            case NavigationController.Views.Volume:
                return volumeComponent;
            case NavigationController.Views.Monitor:
                return monitorComponent;
            case NavigationController.Views.Brightness:
                return brightnessComponent;
            case NavigationController.Views.Notification:
                return notificationComponent;
            case NavigationController.Views.NotchExpanded:
                return expandedComponent;
            case NavigationController.Views.PowerMenu:
                return powerMenuComponent;
            case NavigationController.Views.Music:
                return musicNotificationComponent;
            case NavigationController.Views.ControlCenter:
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
                    NavigationController.navigate(NavigationController.Views.NotchExpanded)
                } else if (wheel.angleDelta.y < 0) {
                    NavigationController.navigate(NavigationController.Views.ControlCenter)
                }
            }

            onEntered: {
                NavigationController.navigate(NavigationController.Views.NotchExpanded)
            }
            onExited: {
                NavigationController.navigate(NavigationController.Views.Clock)
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: NavigationController.navigate(NavigationController.Views.ControlCenter)
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
