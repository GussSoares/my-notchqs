import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "../components/NotchExpanded"
import "../components"
import "../modules"
import "../services"

import Quickshell.Networking

Rectangle {
    id: notch

    property string activeView: "default"
    signal setExpanded(bool value)

    radius: 18
    color: "#1a1b26"

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight
    
    // Garante que elementos arredondados/imagens não esbarrem nas bordas
    clip: true 

    ColumnLayout {
        id: mainLayout
        spacing: 8

        TopSide {}

        Separator {}

        Text {
            text: `${NetworkController.ssid}, ${NetworkController.signalStrength}%`
            color: "#c0caf5"
            font.pixelSize: 12
            font.bold: true
        }

        NetworkIndicator{}
    }
}
