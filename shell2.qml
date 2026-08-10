import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import "components"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.exclusiveZone: 40

            mask: Region {
                item: notch.activeView !== "clock" ? notch.outsideArea : notch
            }

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 800
            color: "transparent"

            Notch {
                id: notch
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                focusedScreen: Hyprland.monitorFor(modelData).focused
            }
        }
    }
}
