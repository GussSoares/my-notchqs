import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../services"

Item {
    id: root

    implicitWidth: 550
    implicitHeight: 80

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        CpuRamMonitor {}
    }
}
