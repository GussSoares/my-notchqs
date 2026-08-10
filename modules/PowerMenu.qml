import Quickshell
import QtQuick
import QtQuick.Layouts
import "../services"

Item {
    id: root

    implicitWidth: 500
    implicitHeight: 80

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        spacing: 10

        Rectangle {
            color: '#24283b'
            Layout.fillWidth: true
            height: 65
            radius: 16

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: PowerController.powerOff()
            }

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: ' '
                    color: 'white'
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Rectangle {
            color: '#24283b'
            Layout.fillWidth: true
            height: 65
            radius: 16

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: PowerController.lock()
            }

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: ' '
                    color: 'white'
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Rectangle {
            color: '#24283b'
            Layout.fillWidth: true
            height: 65
            radius: 16

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: PowerController.suspend()
            }

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: '󰏤 '
                    color: 'white'
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Rectangle {
            color: '#24283b'
            Layout.fillWidth: true
            height: 65
            radius: 16

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: PowerController.reboot()
            }

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: '󰑓 '
                    color: 'white'
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        Rectangle {
            color: '#24283b'
            Layout.fillWidth: true
            height: 65
            radius: 16

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: PowerController.logout()
            }

            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: '󰍃 '
                    color: 'white'
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
