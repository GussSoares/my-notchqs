import QtQuick
import QtQuick.Layouts
import "../../"

Rectangle {
    color: Theme.surface
    width: Math.max(bluetoothLayout.implicitWidth + 20, 130)
    height: 50
    radius: 13

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }

    RowLayout {
        id: bluetoothLayout
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
                text: '󰂱'
                anchors.centerIn: parent
                color: Theme.textPrimary
                font.pixelSize: 18
            }
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: 'Bluetooth'
                color: Theme.textPrimary
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                text: 'Headset'
                color: Theme.textPrimary
                font.pixelSize: 10
            }
        }
    }
}
