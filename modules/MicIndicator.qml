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
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                VolumeController.openWireMixInput()
            } else if (mouse.button === Qt.RightButton) {
                VolumeController.sourceMute()
            }
        }
    }

    RowLayout {
        id: mainLayout
        spacing: 3

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
