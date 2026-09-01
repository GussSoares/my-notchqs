import QtQuick
import QtQuick.Layouts
import "../services"
import "../"

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
        onClicked: {
            NotificationController.launch(NotificationController.lastNotification.id)
            NavigationController.navigate(NavigationController.Views.Clock)
        }

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
                color: Theme.background
                radius: 16
                visible: parent.status !== Image.Ready
                Text {
                    anchors.centerIn: parent
                    text: "󰂚"
                    color: Theme.accent
                }
            }
        }

        ColumnLayout {
            spacing: 3

            Text {
                text: summary
                color: Theme.textPrimary
                font.pixelSize: 14
                font.bold: true

                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: body
                color: Theme.textPrimary
                font.pixelSize: 11

                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
    }
}
