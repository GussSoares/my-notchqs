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
        
        // Propriedade com a data/hora atual que é atualizada a cada segundo
        property var now: new Date()

        interval: 1000 // Dispara a cada 1 segundo (1000 ms)
        running: true
        repeat: true

        onTriggered: clockTimer.now = new Date()
    }
}