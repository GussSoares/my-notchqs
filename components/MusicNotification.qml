import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import Quickshell
import "../services"
import "../"

Item {
    id: root

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 12

        Image {
            id: albumArt
            source: MprisController.artUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true

            Layout.preferredHeight: 20
            Layout.preferredWidth: 20
            Layout.alignment: Qt.AlignVCenter

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: albumArt.width
                    height: albumArt.height
                    radius: 16
                }
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.background
                radius: 16
                visible: albumArt.status !== Image.Ready

                Text {
                    anchors.centerIn: parent
                    text: "󰎈"
                    color: Theme.textPrimary
                    font.pixelSize: 14
                }
            }
        }

        Item {
            implicitWidth: 100
            implicitHeight: 20
            clip: true
            Text {
                id: slidingText
                text: MprisController.trackTitle
                color: Theme.textPrimary
                font.pixelSize: 14
                x: 0

                NumberAnimation {
                    id: animation
                    target: slidingText
                    property: "x"
                    from: 0
                    to: -slidingText.contentWidth
                    duration: 5000

                    onFinished: {
                        animation.from = parent.width 
                        animation.start()
                    }
                }

                Component.onCompleted: {
                    animation.start()
                }
            }
        }
    }
}
