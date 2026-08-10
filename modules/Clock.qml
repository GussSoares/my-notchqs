import Quickshell
import QtQuick
import QtQuick.Layouts


Text {
    id: root

    property string format: "hh:mm"

    text: Qt.formatDateTime(clock.date, root.format)
    color: "#c0caf5"
    font.pixelSize: 14
    font.bold: true
    Layout.alignment: Qt.AlignVCenter

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
