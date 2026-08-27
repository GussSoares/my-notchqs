import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../" // Importa o Theme
import "../../services" // Importa o VolumeController / NavigationController

Item {
    id: volumeView

    // Dimensões recomendadas para o estado compacto do Notch
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    clip: true

    // Assumindo que seu controller expõe a propriedade 'volume' (0-100 ou 0.0-1.0)
    // e o método 'setVolume(value)' ou 'adjustVolume(delta)'
    readonly property var controller: VolumeController

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 12

        // Ícone dinâmico baseado no nível de volume / mute
        Rectangle {
            width: 32
            height: 32
            radius: 16
            color: Theme.surface

            // Suporta clique no ícone para alternar Mute
            TapHandler {
                onTapped: volumeView.controller.sinkMute()
            }

            Text {
                anchors.centerIn: parent
                color: Theme.textPrimary
                font.pixelSize: 16

                text: {
                    if (volumeView.controller.lastAudioMuted || volumeSlider.value === 0)
                        return "󰝟"; // Mute
                    if (volumeSlider.value < 0.33)
                        return "󰕿"; // Volume Baixo
                    if (volumeSlider.value < 0.66)
                        return "󰖀"; // Volume Médio
                    return "󰕾"; // Volume Alto
                }
            }
        }

        // Slider Personalizado para o Notch
        Slider {
            id: volumeSlider
            hoverEnabled: false

            MouseArea {
                anchors.fill: parent
                cursorShape: volumeSlider.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor

                acceptedButtons: Qt.NoButton
            }

            Layout.preferredWidth: 160
            Layout.preferredHeight: 28

            from: 0.0
            to: 1.0
            // Sincroniza com a propriedade do controller sem quebrar binding
            value: volumeView.controller.lastAudioVolume

            // Atualiza o volume real apenas durante a interação do usuário
            onMoved: {
                volumeView.controller.setVolume(volumeSlider.value);
            }

            // 1. Estilização do Fundo (Trilhos)
            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 8
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: 4
                color: Theme.surface

                // Parte preenchida (Progresso)
                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    color: Theme.textSecondary
                    radius: 4
                }
            }

            // 2. Estilização do Indicador (Handle)
            // handle: Rectangle {
            //     x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
            //     y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
            //     implicitWidth: 16
            //     implicitHeight: 16
            //     radius: 8
            //     color: volumeSlider.pressed ? Theme.textPrimary : Theme.surface
            //     border.color: Theme.textSecondary
            //     border.width: 1

            //     MouseArea {
            //         anchors.fill: parent
            //         cursorShape: volumeSlider.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor

            //         acceptedButtons: Qt.NoButton
            //     }

            //     Behavior on implicitWidth {
            //         NumberAnimation {
            //             duration: 100
            //         }
            //     }
            //     Behavior on implicitHeight {
            //         NumberAnimation {
            //             duration: 100
            //         }
            //     }
            // }
            handle: Item {
                implicitWidth: 0
                implicitHeight: 0
            }
        }

        // Porcentagem textual
        Text {
            Layout.preferredWidth: 32
            text: Math.round(volumeSlider.value * 100) + "%"
            color: Theme.textPrimary
            font.pixelSize: 11
            font.bold: true
            horizontalAlignment: Text.AlignRight
        }
    }

    // 💡 Interação por Scroll (Roda do mouse em qualquer ponto do componente)
    WheelHandler {
        id: wheelHandler

        // Impede o scroll de propagar para telas de fundo
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

        onWheel: event => {
            // Suavidade no ajuste: sobe/desce em passos de 2% ou 5%
            let delta = event.angleDelta.y > 0 ? 0.05 : -0.05;
            let newValue = Math.min(Math.max(volumeSlider.value + delta, 0.0), 1.0);

            volumeView.controller.setVolume(newValue);
        }
    }
}
