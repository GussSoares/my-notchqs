// modules/BatteryBar.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../services"
import "../"

RowLayout {
    id: root
    spacing: 8
    visible: !BatteryController.isUnavailable

    // Ícone dinâmico usando ícones NerdFonts
    Text {
        text: {
            if (BatteryController.isCharging) return "󰂄"

            let p = BatteryController.chargePercentage * 100
            if (p <= 10) return "󰁺"
            if (p <= 20) return "󰁻"
            if (p <= 30) return "󰁼"
            if (p <= 40) return "󰁽"
            if (p <= 50) return "󰁾"
            if (p <= 60) return "󰁿"
            if (p <= 70) return "󰂀"
            if (p <= 80) return "󰂁"
            if (p <= 90) return "󰂂"
            return "󰁹"
        }
        color: {
            if (BatteryController.isCharging) return Theme.success // Verde
            if (BatteryController.chargePercentage <= 0.15) return Theme.error // Vermelho crítico
            return Theme.textPrimary
        }
        font.pixelSize: 16
    }

    // Texto da porcentagem
    Text {
        text: Math.round(BatteryController.chargePercentage * 100) + "%"
        color: Theme.textPrimary
        font.pixelSize: 12
        font.bold: true
    }
}