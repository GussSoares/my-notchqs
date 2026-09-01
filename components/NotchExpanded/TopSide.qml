import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../modules"
import "../../"

Item {
    id: root

    implicitWidth: 550
    implicitHeight: 70

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        MiniMedia {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 160
            Layout.maximumWidth: 160
            Layout.fillWidth: true 
        }

        Item { Layout.fillWidth: true }

        ColumnLayout {
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            Clock {
                font.pixelSize: 22
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Clock {
                format: "MMMM dd, yyyy"
                font.pixelSize: 11
                color: Theme.textPrimary
                Layout.alignment: Qt.AlignHCenter
            }
        }

        Item { Layout.fillWidth: true }

        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 160
            Layout.maximumWidth: 160
            Layout.fillWidth: true

            RowLayout {
                spacing: 3
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                VolumeIndicator {}
                MicIndicator {}
                Battery {}
            }
        }
    }
}