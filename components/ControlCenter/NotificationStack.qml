Item {
    id: root
    width: 320
    height: expanded ? 500 : 200 // O container cresce quando expandido

    // Propriedade que controla se a pilha está aberta ou fechada
    property bool expanded: false

    // Componente Base para as Notificações
    component NotificationCard: Rectangle {
        id: card
        width: 300
        height: 80
        radius: 12
        border.color: "#33ffffff"
        anchors.horizontalCenter: parent.horizontalCenter

        // Índice deste cartão na pilha (0 = topo/primeiro)
        property int index: 0

        // Lógica de posição baseada no estado 'expanded'
        // Fechado: Ficam um atrás do outro (y: 0, 8, 16...)
        // Expandido: Ficam em lista (y: 0, 90, 180...) com espaçamento de 10px
        y: root.expanded ? (index * (height + 10)) : (index * 8)

        // Lógica de tamanho e profundidade (apenas quando fechado)
        // Fechado: Os de trás ficam progressivamente menores e atrás (z menor)
        // Expandido: Todos ficam com tamanho normal e mesma prioridade
        scale: root.expanded ? 1.0 : (1.0 - (index * 0.04))
        z: 100 - index

        // Opacidade reduzida para os cartões de trás quando fechado
        opacity: root.expanded ? 1.0 : (1.0 - (index * 0.2))

        // Animação suave para todas as transições
        Behavior on y {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuint
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutQuint
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }

    // Pilha de Cartões (O primeiro declarado fica visualmente no topo quando fechado)
    NotificationCard {
        index: 0
        color: "#2d2d30"
        Text {
            text: "<b>WhatsApp</b> • Agora"
            color: "white"
            x: 15
            y: 15
        }
        Text {
            text: "Mensagem de João: Fala cara, blz?"
            color: "#aaaaaa"
            x: 15
            y: 40
        }
    }

    NotificationCard {
        index: 1
        color: "#2d2d30"
        Text {
            text: "<b>WhatsApp</b> • 5m atrás"
            color: "white"
            x: 15
            y: 15
        }
        Text {
            text: "Mensagem de Maria: Você viu aquilo?"
            color: "#aaaaaa"
            x: 15
            y: 40
        }
    }

    NotificationCard {
        index: 2
        color: "#2d2d30"
        Text {
            text: "<b>WhatsApp</b> • 15m atrás"
            color: "white"
            x: 15
            y: 15
        }
        Text {
            text: "Mensagem de Grupo: [Foto]"
            color: "#aaaaaa"
            x: 15
            y: 40
        }
    }

    // Área de clique invisível que cobre toda a pilha para alternar o estado
    MouseArea {
        anchors.fill: parent
        onClicked: root.expanded = !root.expanded
    }
}
