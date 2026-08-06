import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    // Variável de estado global da barra
    property bool isExpanded: false

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: backdropWindow
            required property var modelData
            screen: modelData
            visible: root.isExpanded

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: 0 // Não interfere nas janelas do Hyprland!

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: root.isExpanded = false
            }
        }
    }

    // Variants faz a barra ser renderizada em todos os monitores conectados
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: barWindow
            required property var modelData
            screen: modelData
            //aboveWindows: true

            WlrLayershell.layer: root.isExpanded ? WlrLayer.Overlay : WlrLayer.Top
            WlrLayershell.exclusiveZone: 50

            mask: Region {
                item: notch // id do seu Rectangle/Notch
            }

            // Ancoramos a janela no topo da tela
            anchors {
                top: true
                left: true
                right: true
            }

            // A janela ocupa uma altura fixa transparente no topo
            implicitHeight: 200
            color: "transparent"

            // O Notch central em formato de cápsula
            Rectangle {
                id: notch

                property int widthRest: 340
                property int widthHover: 380
                property int widthExpanded: 500

                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                // Cores e estética no estilo iOS
                color: "#16161e"
                border.color: "#2ac3de"
                border.width: mouseArea.containsMouse ? 2 : 1
                radius: 20

                // Transição suave de largura e altura (Comportamento Reativo)
                implicitWidth: root.isExpanded ? widthExpanded : (mouseArea.containsMouse ? widthHover : widthRest)
                implicitHeight: root.isExpanded ? 140 : 40

                // Suavização das animações
                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }

                // Captura de eventos de Hover e Clique
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    // Alterna entre expandido e recolhido ao clicar
                    onClicked: {
                        root.isExpanded = !root.isExpanded;
                        console.log('lAAAAAAA');
                    }

                    // Captura o scroll do mouse
                    onWheel: wheel => {
                        // wheel.angleDelta.y retorna positivo ao rolar para CIMA e negativo ao rolar para BAIXO
                        if (wheel.angleDelta.y > 0) {
                            console.log("Scroll para CIMA detectado!");
                            root.isExpanded = true;
                        } else if (wheel.angleDelta.y < 0) {
                            console.log("Scroll para BAIXO detectado!");
                            root.isExpanded = false;
                        }

                        // Exibe o valor exato do deslocamento para depuração
                        console.log("Delta do wheel:", wheel.angleDelta.y);
                    }

                    onEntered: {
                        root.isExpanded = true
                    }

                    onExited: {
                        root.isExpanded = false
                    }
                }

                // Conteúdo Módulos do Notch
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    Layout.fillWidth: true

                    // BARRA RESUMIDA (Modo Normal)
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24
                        spacing: 10

                        // 1. Texto (Ícone + Título)
                        RowLayout {
                            spacing: 8
                            Layout.alignment: Qt.AlignVCenter

                            Rectangle {
                                width: 12
                                height: 12
                                radius: 6
                                color: mouseArea.containsMouse ? "#f7768e" : "#7aa2f7"

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                            }

                            Text {
                                text: root.isExpanded ? "Painel de Controle" : "Hyprland"
                                color: "#c0caf5"
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }

                        // Espaçador 1 (Space-between entre Texto e Monitor)
                        Item {
                            Layout.fillWidth: true
                        }

                        // 2. Monitor (Centro)
                        Monitor {
                            Layout.alignment: Qt.AlignVCenter
                        }

                        // Espaçador 2 (Space-between entre Monitor e Timer)
                        Item {
                            Layout.fillWidth: true
                        }

                        // 3. Timer / Relógio (Direita)
                        Text {
                            text: Qt.formatDateTime(new Date(), "hh:mm")
                            color: "#7dcfff"
                            font.pixelSize: 13
                            font.bold: true
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    // PAINEL EXPANDIDO (Aparece apenas se isExpanded = true)
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        visible: root.isExpanded
                        opacity: root.isExpanded ? 1.0 : 0.0
                        spacing: 8

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }

                        // Divisor visual
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#24283b"
                        }

                        // Exemplo de Ações Rápidas dentro do Popup
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            // Botão Terminal
                            Rectangle {
                                Layout.fillWidth: true
                                height: 32
                                radius: 8
                                color: btnTermArea.containsMouse ? "#414868" : "#24283b"

                                Text {
                                    anchors.centerIn: parent
                                    text: "Terminal"
                                    color: "#c0caf5"
                                    font.pixelSize: 11
                                }

                                MouseArea {
                                    id: btnTermArea
                                    Process {
                                        id: lauchKitty
                                        command: ["kitty"]
                                        running: false
                                    }
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        lauchKitty.running = true;
                                        root.isExpanded = false;
                                    }
                                }
                            }

                            // Botão Fechar Painel
                            Rectangle {
                                Layout.fillWidth: true
                                height: 32
                                radius: 8
                                color: btnCloseArea.containsMouse ? "#f7768e" : "#24283b"

                                Text {
                                    anchors.centerIn: parent
                                    text: "Fechar"
                                    color: btnCloseArea.containsMouse ? "#1a1b26" : "#c0caf5"
                                    font.pixelSize: 11
                                    font.bold: true
                                }

                                MouseArea {
                                    id: btnCloseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: root.isExpanded = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
