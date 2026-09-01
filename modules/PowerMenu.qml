import Quickshell
import QtQuick
import QtQuick.Layouts
import "../services"
import "../"

Item {
    id: root

    implicitWidth: 500
    implicitHeight: 80

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        // onEntered: NavigationController.navigate(NavigationController.Views.PowerMenu)
        onExited: NavigationController.navigate(NavigationController.Views.Clock)
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        Rectangle {
            color: Theme.surface
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
                    color: Theme.textPrimary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Rectangle {
            color: Theme.surface
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
                    color: Theme.textPrimary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Rectangle {
            color: Theme.surface
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
                    color: Theme.textPrimary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        Rectangle {
            color: Theme.surface
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
                    color: Theme.textPrimary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        Rectangle {
            color: Theme.surface
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
                    color: Theme.textPrimary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
