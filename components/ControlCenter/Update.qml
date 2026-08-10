import QtQuick
import QtQuick.Layouts
import "../../"
import "../../services"

Rectangle {
    color: Theme.surface
    width: Math.max(ramLayout.implicitWidth + 20, 130)
    height: 50
    radius: 13

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: UpdatesController.update()
    }

    RowLayout {
        id: ramLayout
        spacing: 8
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10

        Rectangle {
            width: 30
            height: 30
            radius: 15
            color: Theme.textSecondary

            Text {
                text: UpdatesController.hasUpdates ? "󱍷" : "󰂪"
                anchors.centerIn: parent
                color: UpdatesController.hasUpdates ? Theme.error : Theme.accent
                font.pixelSize: 18
            }
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: 'Update Packages'
                color: Theme.textPrimary
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: {
                    if (UpdatesController.text === '0') {
                        return `Already updated!`
                    } else {
                        return `${UpdatesController.text} packages to update`
                    }
                }
                color: Theme.textPrimary
                font.pixelSize: 10
            }
        }
    }
}
