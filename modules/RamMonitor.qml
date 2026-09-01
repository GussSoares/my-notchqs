import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../services"
import "../modules"
import "../"

Item {
    id: root
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    function getColor(value) {
        if (value < 40)
            return Theme.success;
        else if (value >= 40 && value <= 60)
            return Theme.accent;
        else if (value > 60)
            return Theme.error;
        return Theme.success;
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
            text: {
                if (MonitorController.ramUsage < 40)
                    return "󰾆 ";
                else if (MonitorController.ramUsage >= 40 && MonitorController.ramUsage <= 60)
                    return "󰾅 ";
                else if (MonitorController.ramUsage > 60)
                    return "󰓅 ";
                return "󰾆 ";
            }
            color: root.getColor(MonitorController.ramUsage)
            font.pixelSize: 14
        }

        Text {
            text: "RAM " + MonitorController.ramUsage + "%"
            color: MonitorController.ramUsage > 85 ? Theme.error : Theme.textPrimary
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
