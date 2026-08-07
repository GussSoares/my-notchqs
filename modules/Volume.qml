// modules/Volume.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io // Necessário para executar o wpctl

RowLayout {
    id: root
    spacing: 8

    property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        // active volume and mute properties
        objects: [root.sink]
    }

    Process {
        id: wpctlProcess
    }

    function setVolume(val) {
        // Envia o valor (de 0.0 a 1.0) para o Pipewire via wpctl
        wpctlProcess.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", val.toFixed(2)]
        wpctlProcess.running = true
    }

    function getVolumeColor() {
        if (root.sink && root.sink.audio && root.sink.audio.muted) {
            // muted
            return "#565f89"
        } else if (Math.round(root.sink.audio.volume * 100) > 100) {
            // volume > 100
            return "#ed8796"
        } else {
            // volume > 0 and volume < 100
            return "#7aa2f7"
        }
    }

    function getVolumePercentage() {
        return Math.round(root.sink.audio.volume * 100)
    }

    Layout.preferredWidth: 200

    // --- ÍCONE DE VOLUME ---
    Text {
        text: {
            if (!root.sink || !root.sink.audio) return "󰝟"
            if (root.sink.audio.muted) return "󰝟"
            let vol = root.sink.audio.volume * 100
            if (vol < 33) return "󰕿"
            if (vol < 66) return "󰖀"
            return "󰕾"
        }
        color: (root.sink && root.sink.audio && root.sink.audio.muted) ? "#f7768e" : "#c0caf5"
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
        value: (root.sink && root.sink.audio) ? root.sink.audio.volume : 0.0

        // Atualiza o volume no sistema ao arrastar a barra
        onMoved: {
            root.setVolume(volumeSlider.value)
        }

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
        text: (root.sink && root.sink.audio) ? root.getVolumePercentage() + "%" : "0%"
        color: "#c0caf5"
        font.pixelSize: 11
        font.bold: true
        Layout.preferredWidth: 35
        horizontalAlignment: Text.AlignRight
    }
}