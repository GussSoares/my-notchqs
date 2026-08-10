pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

QtObject {
    id: controller

    property var sink: Pipewire.defaultAudioSink
    property var source: Pipewire.defaultAudioSource
    property var _tracker: PwObjectTracker {
        objects: [
            controller.sink,
            controller.source
        ]
    }

    property bool isInitialized: false
    property real lastAudioVolume: -1
    property bool lastAudioMuted: false

    property real lastMicVolume: -1
    property bool lastMicMuted: false

    signal audioVolumeTriggered()
    signal micVolumeTriggered()

    Component.onCompleted: {
        Qt.callLater(() => {
            if (controller.sink && controller.sink.audio) {
                controller.lastAudioVolume = controller.sink.audio.volume
                controller.lastAudioMuted = controller.sink.audio.muted
            }
            if (controller.source && controller.source.audio) {
                controller.lastMicVolume = controller.source.audio.volume
                controller.lastMicMuted = controller.source.audio.muted
            }
            controller.isInitialized = true;
        })
    }

    property var connectionsSink: Connections {
        target: controller.sink ? controller.sink.audio : null

        function onVolumeChanged() {
            if (!controller.isInitialized || !controller.sink || !controller.sink.audio) {
                return
            }

            let currentVol = controller.sink.audio.volume
            if (Math.abs(currentVol - controller.lastAudioVolume) > 0.001) {
                controller.lastAudioVolume = currentVol
                controller.audioVolumeTriggered()
            }
        }

        function onMutedChanged() {
            if (!controller.isInitialized || !controller.sink || !controller.sink.audio) {
                return
            }

            let currentMuted = controller.sink.audio.muted
            if (currentMuted !== controller.lastAudioMuted) {
                controller.lastAudioMuted = currentMuted
                controller.audioVolumeTriggered()
            }
        }
    }

    property var connectionsSource: Connections {
        target: controller.source ? controller.source.audio : null

        function onVolumeChanged() {
            if (!controller.isInitialized || !controller.source || !controller.source.audio) {
                return
            }

            let currentVol = controller.source.audio.volume
            if (Math.abs(currentVol - controller.lastMicVolume) > 0.001) {
                controller.lastMicVolume = currentVol
                controller.micVolumeTriggered()
            }
        }

        function onMutedChanged() {
            if (!controller.isInitialized || !controller.source || !controller.source.audio) {
                return
            }

            let currentMuted = controller.source.audio.muted
            if (currentMuted !== controller.lastMicMuted) {
                controller.lastMicMuted = currentMuted
                controller.micVolumeTriggered()
            }
        }
    }

    property var volumeControlProcess: Process {
        command: ["kitty", "--class", "volume-floating", "-e", "wiremix", "--tab", "output"]
        
    }
    property var microphoneControlProcess: Process {
        command: ["kitty", "--class", "volume-floating", "-e", "wiremix", "--tab", "input"]
        
    }

    function openWireMixOutput() {
        volumeControlProcess.running = true
    }
    function openWireMixInput() {
        microphoneControlProcess.running = true
    }
}
