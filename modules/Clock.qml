import QtQuick
import QtQuick.Layouts

Text {
    id: root

    text: Qt.formatDateTime(clockTimer.now, "hh:mm")
    color: "#7dcfff"
    font.pixelSize: 13
    font.bold: true
    Layout.alignment: Qt.AlignVCenter

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        
        property var now: new Date()

        onTriggered: clockTimer.now = new Date()
    }
}