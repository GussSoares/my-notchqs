import QtQuick
import QtQuick.Layouts
import "../../"

Rectangle {
    color: Theme.surface
    width: Math.max(ramLayout.implicitWidth + 20, 130)
    height: 50
    radius: 13

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: MonitorController.openBtop()
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
                text: MonitorController.ramIcon
                anchors.centerIn: parent
                color: MonitorController.ramColor
                font.pixelSize: 18
            }
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: 'Ram'
                color: Theme.textPrimary
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: MonitorController.ramUsage + "%"
                color: Theme.textPrimary
                font.pixelSize: 10
            }
        }
    }
}
