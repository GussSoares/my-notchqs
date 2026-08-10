import QtQuick
import QtQuick.Layouts
import "../../"
import "../../services"

Rectangle {
    color: Theme.surface
    width: Math.max(cpuLayout.implicitWidth + 20, 130)
    height: 50
    radius: 13

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: MonitorController.openBtop()
    }

    RowLayout {
        id: cpuLayout
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
                text: MonitorController.cpuIcon
                anchors.centerIn: parent
                color: MonitorController.cpuColor
                font.pixelSize: 18
            }
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: 'CPU'
                color: Theme.textPrimary
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: MonitorController.cpuUsage + "%"
                color: Theme.textPrimary
                font.pixelSize: 10
            }
        }
    }
}
