import QtQuick
import QtQuick.Layouts
import "../../"

Rectangle {
    color: Theme.surface
    width: Math.max(wifiLayout.implicitWidth + 20, 130)
    height: 50
    radius: 13

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: NetworkController.openGazelle()
    }

    RowLayout {
        id: wifiLayout
        spacing: 8
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10

        Rectangle {
            width: 30
            height: 30
            radius: 14
            color: Theme.textSecondary

            Text {
                text: ''
                anchors.centerIn: parent
                color: NetworkController.isConnected ? Theme.accent : Theme.surface
                font.pixelSize: 18
            }
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: 'Wifi'
                color: Theme.textPrimary
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: NetworkController.ssid
                color: Theme.textPrimary
                font.pixelSize: 10
            }
        }
    }
}
