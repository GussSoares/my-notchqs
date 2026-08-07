import QtQuick
import QtQuick.Layouts
import "../modules"

RowLayout {
    id: root
    property bool isExpanded: false
    property bool isHovered: false

    Layout.fillWidth: true
    Layout.preferredHeight: 24
    spacing: 10

    // 1. Esquerda: Ícone + Título
    RowLayout {
        spacing: 8
        Layout.alignment: Qt.AlignVCenter

        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: root.isHovered ? "#f7768e" : "#7aa2f7"

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Text {
            text: root.isExpanded ? "Painel de Controle" : "Hyprland"
            color: "#c0caf5"
            font.pixelSize: 13
            font.bold: true
        }
    }

    // Espaçador 1 (Space-between entre Texto e Monitor)
    Item {
        Layout.fillWidth: true
    }

    // 2. Centro: Monitor
    Monitor {
        Layout.alignment: Qt.AlignVCenter
    }

    // Espaçador 2 (Space-between entre Monitor e Relógio)
    Item {
        Layout.fillWidth: true
    }

    // 3. Direita: Relógio Simples
    // Text {
    //     text: Qt.formatDateTime(new Date(), "hh:mm")
    //     color: "#7dcfff"
    //     font.pixelSize: 13
    //     font.bold: true
    //     Layout.alignment: Qt.AlignVCenter
    // }

    Clock {}
}
