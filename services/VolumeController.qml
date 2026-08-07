pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

QtObject {
    id: controller

    // property string activeView: "default"
    property var sink: Pipewire.defaultAudioSink
    property var _tracker: PwObjectTracker {
        objects: [controller.sink]
    }

    property bool isInitialized: false
    property real lastVolume: -1
    property bool lastMuted: false

    signal volumeTriggered()

    // property var restoreTimer: Timer {
    //     interval: 2500
    //     repeat: false
    //     onTriggered: controller.activeView = "default"
    // }

    // function triggerTransientView(viewName) {
    //     controller.activeView = viewName
    //     restoreTimer.restart()
    // }

    Component.onCompleted: {
        Qt.callLater(() => {
            if (controller.sink && controller.sink.audio) {
                controller.lastVolume = controller.sink.audio.volume
                controller.lastMuted = controller.sink.audio.muted
            }
            controller.isInitialized = true;
        })
    }

    property var connections: Connections {
        target: controller.sink ? controller.sink.audio : null

        function onVolumeChanged() {
            if (!controller.isInitialized || !controller.sink || !controller.sink.audio) {
                return
            }

            let currentVol = controller.sink.audio.volume
            if (Math.abs(currentVol - controller.lastVolume) > 0.001) {
                controller.lastVolume = currentVol
                // controller.triggerTransientView("volume")
                controller.volumeTriggered()
            }
        }

        function onMutedChanged() {
            if (!controller.isInitialized || !controller.sink || !controller.sink.audio) {
                return
            }

            let currentMuted = controller.sink.audio.muted
            if (currentMuted !== controller.lastMuted) {
                controller.lastMuted = currentMuted
                // controller.triggerTransientView("volume")
                controller.volumeTriggered()
            }
        }
    }
}
