// modules/MediaWidget.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../services"

Rectangle {
    id: root
    width: 320
    height: 80
    color: "#1a1b26"
    radius: 12
    
    // Esconde o widget se nenhum player estiver aberto
    visible: MprisController.hasPlayer

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // 1. Thumbnail / Capa do Álbum
        Rectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            radius: 8
            color: "#24283b"
            clip: true // Garante que a imagem respeite os cantos arredondados

            Image {
                anchors.fill: parent
                // artUrl vem no formato 'file://...' ou 'https://...'
                source: MprisController.artUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                
                // Ícone padrão caso não haja capa
                Text {
                    anchors.centerIn: parent
                    visible: parent.status !== Image.Ready
                    text: "󰎈" // Ícone NerdFont
                    color: "#a9b1d6"
                    font.pixelSize: 24
                }
            }
        }

        // 2. Informações da Música (Título e Artista)
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: MprisController.trackTitle
                color: "#c0caf5"
                font.bold: true
                font.pixelSize: 13
                elide: Text.ElideRight // Adiciona '...' se o texto for muito grande
                Layout.fillWidth: true
            }

            Text {
                text: MprisController.trackArtist
                color: "#a9b1d6"
                font.pixelSize: 11
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // 3. Botões de Controle (Anterior, Play/Pause, Próximo)
        RowLayout {
            spacing: 4

            // Botão Anterior
            Button {
                flat: true
                text: "󰒮" // NerdFont
                onClicked: MprisController.previous()
            }

            // Botão Play/Pause Dinâmico
            Button {
                flat: true
                text: MprisController.isPlaying ? "󰏤" : "󰐊"
                onClicked: MprisController.togglePlayPause()
            }

            // Botão Próximo
            Button {
                flat: true
                text: "Draft" // NerdFont ou "󰒞"
                onClicked: MprisController.next()
            }
        }
    }
}