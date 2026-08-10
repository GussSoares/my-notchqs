import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../services"
import "../"

Rectangle {
    id: root

    implicitWidth: layout.implicitWidth + 10
    implicitHeight: 20
    radius: 16
    color: Theme.surface

    visible: UpdatesController.hasUpdates

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: UpdatesController.hasUpdates ? "󱍷" : "󰂪"
            color: UpdatesController.hasUpdates ? Theme.error : Theme.accent // Vermelho se tiver update, azul se atualizado
            font.pixelSize: 12
        }

        Text {
            text: UpdatesController.text
            color: Theme.textPrimary
            font.pixelSize: 12
            visible: text !== ""
        }
    }

    TapHandler {
        onTapped: UpdatesController.update()
    }

    Component.onCompleted: {
        UpdatesController.updateProcess.running = true
    }
}
