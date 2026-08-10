import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../services"

RowLayout {
    id: root
    anchors.leftMargin: 6
    anchors.rightMargin: 6
    spacing: 5

    function getColor(value) {
        if (value < 40) return "#9ece6a"
        else if (value >= 40 && value <= 60) return "#7aa2f7"
        else if (value > 60) return "#f7768e"
        return "#9ece6a"
    }

    Rectangle {
        color: '#24283b'
        Layout.fillWidth: true
        height: 65
        radius: 13

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: MonitorController.openBtop()
        }

        ColumnLayout {
            spacing: 0
            anchors.fill: parent
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: '---   ---'
                color: getColor(MonitorController.cpuUsage)
                font.pixelSize: 28
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "CPU " + MonitorController.cpuUsage + "%"
                font.pixelSize: 12
                color: "#c0caf5"
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    Rectangle {
        color: '#24283b'
        Layout.fillWidth: true
        height: 65
        radius: 13

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: MonitorController.openBtop()
        }

        ColumnLayout {
            spacing: 0
            anchors.fill: parent
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: '--- 󰾆  ---'
                color: getColor(MonitorController.ramUsage)
                font.pixelSize: 28
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "RAM " + MonitorController.ramUsage + "%"
                color: "#c0caf5"
                font.pixelSize: 12
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
