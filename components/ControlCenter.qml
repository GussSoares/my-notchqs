import QtQuick
import QtQuick.Layouts
import "../"
import "../components/NotchExpanded"
import "../components/ControlCenter" as ControlCenter

Item {
    id: root

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    clip: true

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

        Paginator { page: 2}
    }
}
