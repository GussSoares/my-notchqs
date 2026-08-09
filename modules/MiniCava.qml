import QtQuick
import QtQuick.Layouts
import "../services"

RowLayout {
    id: root
    spacing: 3
    height: 16

    property int bars: 4

    visible: MprisController.isPlaying

    Repeater {
        model: root.bars

        Item {
            required property int index

            Layout.preferredWidth: 3
            Layout.preferredHeight: root.height

            Rectangle {
                id: bar
                width: parent.width
                height: 3
                color: "#7aa2f7"
                radius: 1.5

                // Trava no fundo do container invisível
                anchors.bottom: parent.bottom

                SequentialAnimation on height {
                    running: MprisController.isPlaying
                    loops: Animation.Infinite

                    NumberAnimation {
                        from: 3
                        to: root.height - (index * 2)
                        duration: 280 + (index * 90)
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        from: root.height - (index * 2)
                        to: 3
                        duration: 220 + (index * 70)
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}