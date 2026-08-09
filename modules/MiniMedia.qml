import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import QtQuick.Controls
import "../services"

Item {
    id: root

    // Define o tamanho implícito para o Notch saber como dimensioná-lo
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: 40

    function fixName(value: string, slice=10): string {
        if (value.length < slice) return value
        return `${value.slice(0, slice)}...`
    }

    MouseArea {
        anchors.fill: parent
        onClicked: MprisController.togglePlayPause()
    }

    RowLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 10

        // 1. Imagem de Capa com Cantos Arredondados
        Image {
            id: albumArt
            source: MprisController.artUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40 // Mantido quadrado para não distorcer
            Layout.alignment: Qt.AlignVCenter

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: albumArt.width
                    height: albumArt.height
                    radius: 8
                }
            }

            // Ícone substituto caso a imagem de capa falhe ou não exista
            Rectangle {
                anchors.fill: parent
                color: "#24283b"
                radius: 8
                visible: albumArt.status !== Image.Ready

                Text {
                    anchors.centerIn: parent
                    text: "󰎈" // Ícone NerdFont de nota musical
                    color: "#a9b1d6"
                    font.pixelSize: 18
                }
            }
        }

        // 2. Título, Artista e MiniCava
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            // Linha com o MiniCava e Título
            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                MiniCava {
                    bars: 3
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: root.fixName(MprisController.trackTitle)
                    color: "#c0caf5"
                    font.pixelSize: 13
                    font.bold: true
                    
                    // O SEGREDO DO ALINHAMENTO:
                    // O elide calcula dinamicamente o espaço e coloca '...' se passar do limite
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }

            // Artista
            Text {
                text: root.fixName(MprisController.trackArtist)
                color: "#a9b1d6"
                font.pixelSize: 10
                
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
    }
}