// NotchCapsule.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../modules"

Rectangle {
    id: notch

    // Define qual visualização está ativa no momento: "default" | "volume" | "media" | etc.
    property string activeView: "default"

    width: layoutStack.implicitWidth + 24
    height: 36
    radius: 18
    color: "#1a1b26"

    // Animação suave para ajustar a largura do Notch se os componentes tiverem tamanhos diferentes
    Behavior on width {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    // --- LÓGICA DO PIPEWIRE E ALTERAÇÃO DE VISÃO ---
    property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [notch.sink]
    }

    // Timer responsável por voltar para o estado padrão após alguns segundos
    Timer {
        id: restoreTimer
        interval: 2500 // Exibe a visão de volume por 2.5 segundos
        repeat: false
        onTriggered: {
            notch.activeView = "default"
            console.log('timer')
        }
    }

    // Função auxiliar para mudar temporariamente de visão
    function triggerTransientView(viewName) {
        notch.activeView = viewName
        restoreTimer.restart() // Reseta a contagem caso o volume continue sendo alterado
    }

    // Escuta mudanças de áudio no sistema
    Connections {
        target: notch.sink ? notch.sink.audio : null

        function onVolumeChanged() {
            // Evita disparar a visão na inicialização do componente
            if (notch.Component.isCompleted) {
                notch.triggerTransientView("volume")
            }
        }

        function onMutedChanged() {
            if (notch.Component.isCompleted) {
                notch.triggerTransientView("volume")
            }
        }
    }

    // --- CONTEÚDO DINÂMICO (STACKLAYOUT) ---
    StackLayout {
        id: layoutStack
        anchors.centerIn: parent

        // Mapeia qual item do StackLayout exibir com base na propriedade activeView
        currentIndex: {
            switch (notch.activeView) {
                case "volume": return 1
                case "default":
                default: return 0
            }
        }

        // --- VISÃO 0: Padrão (Relógio) ---
        Clock {
            id: clockView
            // Animação de fade simples ao aparecer/desaparecer
            opacity: StackLayout.isCurrentItem ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }

        // --- VISÃO 1: Volume ---
        Volume {
            id: volumeView
            opacity: StackLayout.isCurrentItem ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }
}