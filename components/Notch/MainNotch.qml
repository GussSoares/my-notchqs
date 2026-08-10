import QtQuick
import QtQuick.Layouts
import "../../modules"

Item {
    id: root

    implicitWidth: mainLayout.implicitWidth + additionalPadding
    implicitHeight: mainLayout.implicitHeight

    property int additionalPadding: 0

    RowLayout {
        id: mainLayout
        spacing: 10
        anchors.centerIn: parent

        MiniCava {}

        Battery {}

        CPUMonitor { }

        Clock {}

        RamMonitor {}

        Updates {}
    }
}
