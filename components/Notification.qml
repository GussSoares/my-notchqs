import QtQuick
import QtQuick.Layouts
import "../services"

Rectangle {
    id: root

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: 70

    property int idd: 0

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: console.log('clicou' + root.idd)
    }

    Text {
        text: 'lalalalala'
    }
}
