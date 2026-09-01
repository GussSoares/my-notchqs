// modules/Volume.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "../services"
import "../"

Item {
    id: root

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    function getVolumeColor() {
        if (VolumeController.lastAudioMuted) {
            // muted
            return Theme.textSecondary;
        } else if (Math.round(VolumeController.lastAudioVolume * 100) > 100) {
            // volume > 100
            return Theme.error;
        } else {
            // volume > 0 and volume < 100
            return Theme.accent;
        }
    }

    function getVolumePercentage() {
        return Math.round(VolumeController.lastAudioVolume * 100);
    }

    RowLayout {
        id: mainLayout
        spacing: 8
        anchors.centerIn: parent

        Text {
            text: {
                if (VolumeController.lastAudioMuted)
                    return " ";
                let vol = VolumeController.lastAudioVolume * 100;
                if (vol === 0)
                    return " ";
                if (vol < 33)
                    return " ";
                if (vol < 66)
                    return " ";
                return "  ";
            }
            color: (VolumeController.lastAudioMuted) ? Theme.error : Theme.textPrimary
            font.pixelSize: 14
        }

        Slider {
            id: volumeSlider
            Layout.fillWidth: true
            Layout.preferredHeight: 16

            from: 0.0
            to: 1.0

            // Vincula o valor do slider diretamente ao volume reportado pelo Pipewire
            value: VolumeController.lastAudioVolume || 0.0

            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 150
                implicitHeight: 4
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: Theme.border
                clip: true

                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    radius: parent.radius
                    color: root.getVolumeColor()

                    // Animação suave para quando o volume for alterado por atalhos de teclado
                    Behavior on width {
                        enabled: !volumeSlider.pressed // Desativa animação enquanto arrasta para não dar lag
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }

            handle: Item {
                implicitWidth: 0
                implicitHeight: 0
            }

        }

        Text {
            text: VolumeController.lastAudioVolume ? root.getVolumePercentage() + "%" : "0%"
            color: Theme.textPrimary
            font.pixelSize: 11
            font.bold: true
            Layout.preferredWidth: 35
            horizontalAlignment: Text.AlignRight
        }
    }
}
