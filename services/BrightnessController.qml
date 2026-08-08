// services/BrightnessController.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: controller

    property real brightness: 0.0
    property real lastBrightness: -1
    property bool isInitialized: false
    property string device: "intel_backlight"
    readonly property string sysPath: "/sys/class/backlight/" + device

    signal brightnessTriggered()

    property var maxFile: FileView {
        path: controller.sysPath + "/max_brightness"
    }

    property var currentFile: FileView {
        path: controller.sysPath + "/brightness"
    }

    property var updateTimer: Timer {
        interval: 100
        running: controller.isInitialized
        repeat: true
        onTriggered: controller.checkBrightness()
    }

    function checkBrightness() {
        currentFile.reload()
        maxFile.reload()

        let curr = parseFloat(currentFile.text().trim())
        let max = parseFloat(maxFile.text().trim())

        if (isNaN(curr) || isNaN(max) || max <= 0) return

        let newVal = Math.max(0.0, Math.min(1.0, curr / max))

        // Dispara o sinal apenas se a diferença for relevante
        if (Math.abs(newVal - controller.lastBrightness) > 0.005) {
            controller.lastBrightness = newVal
            controller.brightness = newVal

            if (controller.isInitialized) {
                controller.brightnessTriggered()
            }
        }
    }

    Component.onCompleted: {
        Qt.callLater(() => {
            controller.checkBrightness()
            controller.isInitialized = true
        })
    }
}