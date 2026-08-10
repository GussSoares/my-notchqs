import Quickshell
import QtQuick
import QtQuick.Layouts


Text {
    id: root

    property string format: "hh:mm"

    text: Qt.formatDateTime(clock.date, root.format)
    color: "#7dcfff"
    font.pixelSize: 13
    font.bold: true
    Layout.alignment: Qt.AlignVCenter

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
