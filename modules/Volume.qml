// modules/Volume.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io // Necessário para executar o wpctl
import "../services"

RowLayout {
    id: root
    spacing: 8

    function getVolumeColor() {
        if (VolumeController.lastAudioMuted) {
            // muted
            return "#565f89"
        } else if (Math.round(VolumeController.lastAudioVolume * 100) > 100) {
            // volume > 100
            return "#ed8796"
        } else {
            // volume > 0 and volume < 100
            return "#7aa2f7"
        }
    }

    function getVolumePercentage() {
        return Math.round(VolumeController.lastAudioVolume * 100)
    }

    Layout.preferredWidth: 200

    // --- ÍCONE DE VOLUME ---
    Text {
        text: {
            // if (!VolumeController.sink || !VolumeController.sink.audio) return " "
            if (VolumeController.lastAudioMuted) return " "
            let vol = VolumeController.lastAudioVolume * 100
            if (vol === 0) return " "
            if (vol < 33) return " "
            if (vol < 66) return " "
            return "  "
        }
        color: (VolumeController.lastAudioMuted) ? "#f7768e" : "#c0caf5"
        font.pixelSize: 14
    }

    // --- BARRA HORIZONTAL (SLIDER) ---
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
            color: "#414868"
            clip: true

            Rectangle {
                width: volumeSlider.visualPosition * parent.width
                height: parent.height
                radius: parent.radius
                color: root.getVolumeColor()

                // Animação suave para quando o volume for alterado por atalhos de teclado
                Behavior on width {
                    enabled: !volumeSlider.pressed // Desativa animação enquanto arrasta para não dar lag
                    NumberAnimation { duration: 100 }
                }
            }

        }

        handle: Item {
            implicitWidth: 0
            implicitHeight: 0
        }

        // handle: Rectangle {
        //     x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
        //     y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
        //     implicitWidth: 10
        //     implicitHeight: 10
        //     radius: 5
        //     color: volumeSlider.pressed ? "#7aa2f7" : "#bb9af7"

        //     Behavior on x {
        //         enabled: !volumeSlider.pressed
        //         NumberAnimation { duration: 100 }
        //     }
        // }
    }

    // --- TEXTO DA PORCENTAGEM ---
    Text {
        text: VolumeController.lastAudioVolume ? root.getVolumePercentage() + "%" : "0%"
        color: "#c0caf5"
        font.pixelSize: 11
        font.bold: true
        Layout.preferredWidth: 35
        horizontalAlignment: Text.AlignRight
    }
}