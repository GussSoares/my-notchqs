// modules/VolumeIndicator.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"

Item {
    id: root
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    MouseArea {
        anchors.fill: parent
        onClicked: NetworkController.openGazelle()
    }

    function getColor() {
        return NetworkController.isConnected ? "#a6da95" : "#ed8796";
    }

    RowLayout {
        id: mainLayout
        spacing: 8

        // Ícone dinâmico usando ícones NerdFonts
        Text {
            text: {
                if (!NetworkController.isConnected) return "󰤮 "

                let s = NetworkController.signalStrength;
                if (s <= 25) return "󰤟" // Fraco
                if (s <= 50) return "󰤢" // Médio
                if (s <= 75) return "󰤥" // Bom
                return "󰤨"
            }
            color: root.getColor()
            font.pixelSize: 16
        }

        // Texto da porcentagem
        Text {
            text: NetworkController.ssid
            color: root.getColor()
            font.pixelSize: 12
            font.bold: true
        }
    }
}
