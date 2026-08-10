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
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                VolumeController.openWireMixOutput()
            } else if (mouse.button === Qt.RightButton) {
                VolumeController.sinkMute()
            }
        }
    }

    RowLayout {
        id: mainLayout
        spacing: 5

        // Ícone dinâmico usando ícones NerdFonts
        Text {
            text: {
                let p = VolumeController.lastAudioVolume * 100;
                if (p == 0 || VolumeController.lastAudioMuted)
                    return "";
                if (p <= 25)
                    return "";
                if (p <= 50)
                    return "";
                if (p <= 75)
                    return "";
                if (p <= 100)
                    return "";
                return "";
            }
            color: {
                return VolumeController.lastAudioMuted ? "#f7768e" : "#c0caf5";
            }
            font.pixelSize: 16
        }

        // Texto da porcentagem
        Text {
            text: Math.round(VolumeController.lastAudioVolume * 100) + "%"
            color: "#c0caf5"
            font.pixelSize: 12
            font.bold: true
        }
    }
}
