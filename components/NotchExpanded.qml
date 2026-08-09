import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../modules"
import "../services"

Rectangle {
    id: notch

    property string activeView: "default"
    signal setExpanded(bool value)

    radius: 18
    color: "#1a1b26"

    implicitWidth: 550
    implicitHeight: 70
    
    // Garante que elementos arredondados/imagens não esbarrem nas bordas
    clip: true 

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        spacing: 0

        // =================================================================
        // 1. SEÇÃO ESQUERDA (MiniMedia)
        // =================================================================
        // Ocupa até 160px. Se a janela/Notch encolher, ele cede espaço suavemente.
        MiniMedia {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 160
            Layout.maximumWidth: 160
            Layout.fillWidth: true 
        }

        // Mola flexível para empurrar o centro
        Item { Layout.fillWidth: true }

        // =================================================================
        // 2. SEÇÃO CENTRAL (Relógio + Data)
        // =================================================================
        // Fica perfeitamente centralizado no Notch
        ColumnLayout {
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Clock {
                font.pixelSize: 22
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Clock {
                format: "MMMM dd, yyyy"
                font.pixelSize: 11
                color: "#c0caf5"
                Layout.alignment: Qt.AlignHCenter
            }
        }

        // Mola flexível para empurrar a direita
        Item { Layout.fillWidth: true }

        // =================================================================
        // 3. SEÇÃO DIREITA (Relógio Secundário / Status)
        // =================================================================
        // Mesma largura preferida de 160px para garantir a simetria com a esquerda
        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 160
            Layout.maximumWidth: 160
            Layout.fillWidth: true
            // implicitHeight: rightClock.implicitHeight

            // Clock {
            //     id: rightClock
            //     anchors.right: parent.right // Gruda na extrema direita
            //     anchors.verticalCenter: parent.verticalCenter
            //     font.pixelSize: 22
            //     font.bold: true
            // }
            Battery {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}