import QtQuick
import QtQuick.Layouts
import "../services"

Item {
    implicitWidth: Math.min(mainLayout.implicitWidth, maxWidth)
    implicitHeight: mainLayout.implicitHeight

    readonly property var notif: NotificationController.lastNotification

    readonly property string icon: notif ? (notif.image || "") : ""
    readonly property string summary: notif ? (notif.summary || "") : ""
    readonly property string body: notif ? (notif.body || "") : ""

    readonly property int maxWidth: 300

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: NotificationController.launchFromNotification(NotificationController.lastNotification)
        HoverHandler {
            blocking: true
        }
    }

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: 8
        width: Math.min(mainLayout.implicitWidth, maxWidth)

        Image {
            source: icon
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignCenter
            fillMode: Image.PreserveAspectFit

            Rectangle {
                anchors.fill: parent
                color: "#24283b"
                radius: 6
                visible: parent.status !== Image.Ready
                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    color: "#7aa2f7"
                }
            }
        }

        ColumnLayout {
            spacing: 3

            Text {
                text: summary
                color: "#c0caf5"
                font.pixelSize: 14
                font.bold: true

                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: body
                color: "#c0caf5"
                font.pixelSize: 11

                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
    }
}
