import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool isExpanded: false
    signal toggleExpanded()
    signal setExpanded(bool value)

    property int widthRest: 340
    property int widthHover: 380
    property int widthExpanded: 500

    // Cores e estética no estilo iOS
    color: "#16161e"
    border.color: "#2ac3de"
    border.width: hoverHandler.hovered ? 2 : 1
    radius: 20

    // Transição suave de largura e altura (Comportamento Reativo)
    implicitWidth: isExpanded ? widthExpanded : (hoverHandler.hovered ? widthHover : widthRest)
    implicitHeight: isExpanded ? 140 : 40

    // Suavização das animações
    Behavior on implicitWidth {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }
    Behavior on implicitHeight {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    // HoverHandler detecta o mouse sobre o notch (incluindo botões filhos) sem perder o hover
    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered) {
                root.setExpanded(true)
            } else {
                root.setExpanded(false)
            }
        }
    }

    // Captura de eventos de Scroll e Clique sem roubar o hover dos botões filhos
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: false

        onClicked: root.toggleExpanded()

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) root.setExpanded(true)
            else if (wheel.angleDelta.y < 0) root.setExpanded(false)
        }
    }

    // Conteúdo Módulos do Notch
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        CompactBar {
            isExpanded: root.isExpanded
            isHovered: hoverHandler.hovered
        }

        ExpandedPanel {
            isExpanded: root.isExpanded
            onRequestClose: root.setExpanded(false)
        }
    }
}
