import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    id: root
    required property bool isExpanded
    signal requestClose()

    model: Quickshell.screens

    delegate: PanelWindow {
        required property var modelData
        screen: modelData
        visible: root.isExpanded

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusiveZone: 0

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: root.requestClose()
        }
    }
}
