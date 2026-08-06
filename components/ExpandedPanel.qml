import QtQuick
import QtQuick.Layouts
import Quickshell.Io

ColumnLayout {
    id: root
    property bool isExpanded: false
    signal requestClose()

    Layout.fillWidth: true
    Layout.fillHeight: true
    visible: root.isExpanded
    opacity: root.isExpanded ? 1.0 : 0.0
    spacing: 8

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    // Divisor visual
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#24283b"
    }

    // Exemplo de Ações Rápidas dentro do Popup
    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Process {
            id: launchKitty
            command: ["kitty"]
            running: false
        }

        // Botão Terminal
        Rectangle {
            Layout.fillWidth: true
            height: 32
            radius: 8
            color: btnTermArea.containsMouse ? "#414868" : "#24283b"

            Text {
                anchors.centerIn: parent
                text: "Terminal"
                color: "#c0caf5"
                font.pixelSize: 11
            }

            MouseArea {
                id: btnTermArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    launchKitty.running = true
                    root.requestClose()
                }
            }
        }

        // Botão Fechar Painel
        Rectangle {
            Layout.fillWidth: true
            height: 32
            radius: 8
            color: btnCloseArea.containsMouse ? "#f7768e" : "#24283b"

            Text {
                anchors.centerIn: parent
                text: "Fechar"
                color: btnCloseArea.containsMouse ? "#1a1b26" : "#c0caf5"
                font.pixelSize: 11
                font.bold: true
            }

            MouseArea {
                id: btnCloseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.requestClose()
            }
        }
    }
}
