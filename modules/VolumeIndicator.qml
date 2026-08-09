// modules/VolumeIndicator.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"

RowLayout {
    id: root
    spacing: 8

    // Ícone dinâmico usando ícones NerdFonts
    Text {
        text: {
            let p = VolumeController.lastVolume * 100
            if (p == 0) return " "
            if (p <= 25) return " "
            if (p <= 50) return " "
            if (p <= 75) return " "
            if (p <= 100) return " "
            return " "
        }
        color: {
            return VolumeController.lastMuted ? "#f7768e" : "#c0caf5"
        }
        font.pixelSize: 16
    }

    // Texto da porcentagem
    Text {
        text: Math.round(VolumeController.lastVolume * 100) + "%"
        color: "#c0caf5"
        font.pixelSize: 12
        font.bold: true
    }
}
