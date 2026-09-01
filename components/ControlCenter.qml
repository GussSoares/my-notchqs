import QtQuick
import QtQuick.Layouts
import "../"
import "../components/NotchExpanded"
import "../components/ControlCenter" as ControlCenter

Item {
    id: controlCenter

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    clip: true

    HoverHandler {
        onHoveredChanged: {
            if (!hovered) {
                NavigationController.navigate(NavigationController.Views.Clock)
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 8

        RowLayout {
            spacing: 8

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: Theme.border

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: NavigationController.navigate(NavigationController.Views.NotchExpanded)
                }

                Text {
                    text: ''
                    anchors.centerIn: parent
                    color: Theme.textPrimary
                    font.pixelSize: 12
                }
            }


            Text {
                text: 'Control Center'
                font.pixelSize: 18
                color: Theme.textPrimary
                font.bold: true
            }

            Item {Layout.fillWidth: true}

            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: Theme.border

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: NavigationController.navigate(NavigationController.Views.PowerMenu)
                }

                Text {
                    text: '⏻'
                    anchors.centerIn: parent
                    color: Theme.textPrimary
                    font.pixelSize: 12
                }
            }
        }

        RowLayout {
            spacing: 8

            ControlCenter.Wifi {}
            ControlCenter.Bluetooth {}
        }

        RowLayout {
            spacing: 8

            ControlCenter.CPU {}
            ControlCenter.RAM {}
        }

        RowLayout {
            spacing: 8

            ControlCenter.Update {
                Layout.fillWidth: true
            }
        }

        RowLayout {
            spacing: 8

            ControlCenter.Volume {
                Layout.fillWidth: true
            }
        }

        RowLayout {
            spacing: 8

            ControlCenter.Brightness {
                Layout.fillWidth: true
            }
        }

        Separator {}

        

        RowLayout {
            spacing: 8

            Text {
                text: 'Notificações'
                color: Theme.textPrimary
                font.pixelSize: 14
            }
            Item {
                Layout.fillWidth: true
            }
            Text {
                text: ''
                color: Theme.textPrimary
                font.pixelSize: 14

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        NotificationController.clearAll()
                    }
                }
            }
        }

        RowLayout {
            spacing: 8

            ControlCenter.NotificationList {
                Layout.fillWidth: true
            }
        }

        Paginator { page: 2}
    }
}
