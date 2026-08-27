import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../"
import "../../services"

Item {
    id: brightnessView

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    clip: true

    readonly property var controller: BrightnessController

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 12

        Rectangle {
            width: 32
            height: 32
            radius: 16
            color: Theme.surface

            // TapHandler {
            //     onTapped: brightnessView.controller.sinkMute()
            // }

            Text {
                anchors.centerIn: parent
                color: Theme.textPrimary
                font.pixelSize: 16

                text: {
                    if (brightnessView.controller.brightness === 0.0)
                        return "󰃞";
                    if (brightnessSlider.value < 0.33)
                        return "󰃝";
                    if (brightnessSlider.value < 0.66)
                        return "󰃟";
                    return "󰃠";
                }
            }
        }

        Slider {
            id: brightnessSlider
            hoverEnabled: false

            MouseArea {
                anchors.fill: parent
                cursorShape: brightnessSlider.pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor

                acceptedButtons: Qt.NoButton
            }

            Layout.preferredWidth: 160
            Layout.preferredHeight: 28

            from: 0.0
            to: 1.0
            value: brightnessView.controller.lastBrightness

            onMoved: {
                brightnessView.controller.setBrightness(brightnessSlider.value);
            }

            background: Rectangle {
                x: brightnessSlider.leftPadding
                y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 8
                width: brightnessSlider.availableWidth
                height: implicitHeight
                radius: 4
                color: Theme.surface

                Rectangle {
                    width: brightnessSlider.visualPosition * parent.width
                    height: parent.height
                    color: Theme.textSecondary
                    radius: 4
                }
            }

            handle: Item {
                implicitWidth: 0
                implicitHeight: 0
            }
        }

        Text {
            Layout.preferredWidth: 32
            text: Math.round(brightnessSlider.value * 100) + "%"
            color: Theme.textPrimary
            font.pixelSize: 11
            font.bold: true
            horizontalAlignment: Text.AlignRight
        }
    }

    WheelHandler {
        id: wheelHandler

        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

        onWheel: event => {
            let delta = event.angleDelta.y > 0 ? 0.05 : -0.05;
            let newValue = Math.min(Math.max(brightnessSlider.value + delta, 0.0), 1.0);

            // brightnessView.controller.setVolume(newValue);
        }
    }
}
