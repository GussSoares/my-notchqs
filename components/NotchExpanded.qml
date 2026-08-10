import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../components/NotchExpanded"
import "../components"
import "../modules"
import "../services"
import "../"

import Quickshell.Networking

Rectangle {
    id: notch

    radius: 18
    color: Theme.background

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight
    
    clip: true

    ColumnLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 8

        TopSide {}

        Paginator { page: 1 }
    }
}
