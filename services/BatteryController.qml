// services/BatteryController.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

QtObject {
    id: controller

    // O UPower seleciona automaticamente o dispositivo principal de bateria (ex: BAT0, BAT1)
    property var displayDevice: UPower.displayDevice

    // Propriedades expostas (0.0 a 1.0 para manter o mesmo padrão do Brilho e Volume)
    property real chargePercentage: displayDevice ? displayDevice.percentage : 0.0
    property bool isCharging: displayDevice ? displayDevice.state === UPowerDeviceState.Charging : false
    property bool isPluggedIn: displayDevice ? (displayDevice.state === UPowerDeviceState.Charging || 
                                               displayDevice.state === UPowerDeviceState.FullyCharged) : false

    property bool isInitialized: false
    property bool lastChargingState: false

    signal batteryTriggered()

    // Monitora as alterações da bateria
    property var connections: Connections {
        target: controller.displayDevice

        // Chamado quando a porcentagem de carga muda
        function onPercentageChanged() {
            if (controller.isInitialized) {
                controller.batteryTriggered()
            }
        }

        // Chamado quando o carregador é conectado ou desconectado
        function onStateChanged() {
            if (!controller.isInitialized) return

            let currentCharging = controller.isCharging
            if (currentCharging !== controller.lastChargingState) {
                controller.lastChargingState = currentCharging
                controller.batteryTriggered() // Notifica o Notch (ex: mostrar animação de carregando)
            }
        }
    }

    Component.onCompleted: {
        Qt.callLater(() => {
            if (controller.displayDevice) {
                controller.lastChargingState = controller.isCharging
            }
            controller.isInitialized = true
        })
    }
}