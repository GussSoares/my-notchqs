// services/WifiController.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Io

QtObject {
    id: controller

    // 1. Busca a placa Wi-Fi entre os dispositivos do sistema
    // (Garante o funcionamento mesmo com VPN, Docker ou Ethernet conectados)
    readonly property WifiDevice wifiDevice: {
        let devs = Networking.devices.values
        for (let dev of devs) {
            if (dev instanceof WifiDevice) return dev
        }
        return null
    }

    // 2. Obtém a rede que possui conexão ativa no momento
    readonly property WifiNetwork connectedNetwork: {
        if (!wifiDevice) return null

        // Tenta a propriedade nativa do dispositivo
        if (wifiDevice.connectedNetwork) return wifiDevice.connectedNetwork

        // Fallback para varrer as redes registradas na placa
        let nets = wifiDevice.networks.values
        for (let net of nets) {
            if (net.connected) return net
        }
        return null
    }

    // 3. Propriedades expostas para a interface
    readonly property bool isConnected: connectedNetwork !== null
    readonly property string ssid: connectedNetwork?.ssid ?? connectedNetwork?.name ?? "Desconectado"
    
    readonly property int signalStrength: {
        if (!connectedNetwork) return 0
        let sig = connectedNetwork.signalStrength
        return sig <= 1.0 ? Math.round(sig * 100) : Math.round(sig)
    }

    // kitty --class network-floating -e gazelle

    property var gazelleProcess: Process {
        command: ["kitty", "--class", "network-floating", "-e", "gazelle"]
        
    }

    function openGazelle() {
        gazelleProcess.running = true
    }
}