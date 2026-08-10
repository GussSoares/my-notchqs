import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../services"
import "../modules"

Item {
    id: root
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    function getColor(value) {
        if (value < 40)
            return "#a6da95";
        else if (value >= 40 && value <= 60)
            return "#8aadf4";
        else if (value > 60)
            return "#ed8796";
        return "#a6da95";
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: MonitorController.openBtop()
    }

    RowLayout {
        id: mainLayout
        spacing: 4

        Text {
            text: " "
            color: root.getColor(MonitorController.cpuUsage)
            font.pixelSize: 14
        }

        Text {
            text: "CPU " + MonitorController.cpuUsage + "%"
            color: MonitorController.cpuUsage > 80 ? "#f7768e" : "#c0caf5"
            font.pixelSize: 12
            font.bold: true

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }
}
