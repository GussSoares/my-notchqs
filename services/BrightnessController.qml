// services/BrightnessController.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: controller

    property real brightness: 0.0
    property real lastBrightness: -1.0
    property bool isInitialized: false
    property string device: "intel_backlight"

    property real maxBrightness: 1.0

    signal brightnessTriggered()

    // 1. Obtém o valor máximo de brilho
    property var maxProc: Process {
        command: ["brightnessctl", "m", "-d", controller.device]
        running: true

        stdout: SplitParser {
            onRead: data => {
                let max = parseFloat(data.trim())
                if (!isNaN(max) && max > 0) {
                    controller.maxBrightness = max
                    // Lê o valor atual assim que o máximo estiver pronto
                    controller.readProc.running = true
                }
            }
        }
    }

    // 2. Lê o valor atual de brilho
    property var readProc: Process {
        command: ["brightnessctl", "g", "-d", controller.device]

        stdout: SplitParser {
            onRead: data => {
                let current = parseFloat(data.trim())
                if (isNaN(current) || controller.maxBrightness <= 0) return

                let newVal = Math.max(0.0, Math.min(1.0, current / controller.maxBrightness))

                // Aplica a mesma regra de filtro do VolumeController
                if (Math.abs(newVal - controller.lastBrightness) > 0.001) {
                    controller.lastBrightness = newVal
                    controller.brightness = newVal

                    if (controller.isInitialized) {
                        controller.brightnessTriggered()
                    }
                }
            }
        }
    }

    // 3. Monitora eventos em TEMPO REAL do Kernel via udevadm (0% CPU quando ocioso)
    property var monitorProc: Process {
        command: ["udevadm", "monitor", "--subsystem-match=backlight", "--environment"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                // Notifica a leitura do brilho somente quando houver alteração de estado no dispositivo
                if (data.includes("ACTION=change")) {
                    controller.readProc.running = true
                }
            }
        }
    }

    // Lifecycle / Trava de Inicialização
    Component.onCompleted: {
        Qt.callLater(() => {
            controller.isInitialized = true
        })
    }
}