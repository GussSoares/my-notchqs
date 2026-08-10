// modules/Brightness.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Quickshell
import "../services"

Item {
    id: root

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    function getBrightnessPercentage() {
        return Math.abs(BrightnessController.brightness * 100).toFixed(0);
    }

    function getBrightnessIcon() {
        let brightness = root.getBrightnessPercentage();

        if (brightness > 0 && brightness <= 10)
            return "󰃞 ";
        if (brightness > 10 && brightness <= 50)
            return "󰃝 ";
        if (brightness > 50 && brightness <= 90)
            return "󰃟 ";
        if (brightness > 90 && brightness <= 100)
            return "󰃠 ";
    }

    RowLayout {
        id: mainLayout
        spacing: 8
        anchors.centerIn: parent

        Text {
            text: root.getBrightnessIcon()
            color: "#c0caf5"
            font.pixelSize: 14
        }

        Slider {
            id: brightnessSlider
            Layout.fillWidth: true
            Layout.preferredHeight: 16

            from: 0.0
            to: 1.0

            value: BrightnessController.brightness || 0.0
            enabled: false

            background: Rectangle {
                x: brightnessSlider.leftPadding
                y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                implicitWidth: 150
                implicitHeight: 4
                width: brightnessSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: "#414868"
                clip: true

                Rectangle {
                    width: brightnessSlider.visualPosition * parent.width
                    height: parent.height
                    radius: parent.radius
                    color: "#7aa2f7"

                    Behavior on width {
                        enabled: !brightnessSlider.pressed
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }

            handle: Item {
                implicitWidth: 0
                implicitHeight: 0
            }
        }

        Text {
            text: root.getBrightnessPercentage() + "%"
            color: "#c0caf5"
            font.pixelSize: 11
            font.bold: true
            Layout.preferredWidth: 35
            horizontalAlignment: Text.AlignRight
        }
    }
}
