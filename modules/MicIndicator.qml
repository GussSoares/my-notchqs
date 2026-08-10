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
        onClicked: VolumeController.openWireMixInput()
    }

    RowLayout {
        id: mainLayout
        spacing: 8

        Text {
            text: VolumeController.lastMicMuted ? "" : ""
            color: {
                return VolumeController.lastMicMuted ? "#f7768e" : "#c0caf5";
            }
            font.pixelSize: 16
        }

        Text {
            text: Math.round(VolumeController.lastMicVolume * 100) + "%"
            color: "#c0caf5"
            font.pixelSize: 12
            font.bold: true
        }
    }
}
