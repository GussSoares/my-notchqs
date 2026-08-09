import Quickshell
import Quickshell.Wayland
import QtQuick
import "components"

Scope {
    id: root

    // Variável de estado global da barra
    property bool isExpanded: false

    // 1. Camada Transparente de Clique Fora (Overlay)
    BackdropWindow {
        isExpanded: root.isExpanded
        onRequestClose: root.isExpanded = false
    }

    // 2. Barra Principal do Notch (Top Panel)
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            required property var modelData
            screen: modelData

            WlrLayershell.layer: root.isExpanded ? WlrLayer.Overlay : WlrLayer.Top
            WlrLayershell.exclusiveZone: 50 // Espaçamento permanente de 50px no Hyprland

            mask: Region {
                item: notch
            }

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 400
            color: "transparent"

            // Cápsula central do Notch
            // NotchCapsule {
            //     id: notch
            //     anchors.top: parent.top
            //     anchors.topMargin: 10
            //     anchors.horizontalCenter: parent.horizontalCenter

            //     isExpanded: root.isExpanded
            //     onToggleExpanded: root.isExpanded = !root.isExpanded
            //     onSetExpanded: (val) => root.isExpanded = val
            // }

            Notch {
                id: notch
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
