import QtQuick
import QtQuick.Layouts
import "../../"
import "../../services"

Rectangle {

    property var notif

    readonly property string icon: notif ? (notif.image || "") : ""
    readonly property string summary: notif ? (notif.summary || "") : ""
    readonly property string body: notif ? (notif.body || "") : ""

    color: Theme.surface
    width: ListView.view ? ListView.view.width : 0
    height: 50
    radius: 13

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            NotificationController.launch(notif)
        }
    }

    RowLayout {
        id: cpuLayout
        spacing: 8
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10

        Image {
            source: icon ? icon : ''
            asynchronous: true
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignCenter
            fillMode: Image.PreserveAspectFit

            cache: true

            Rectangle {
                anchors.fill: parent
                color: Theme.textSecondary
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
            spacing: 0

            Text {
                text: summary
                color: Theme.textPrimary
                font.pixelSize: 12
                font.bold: true

                Layout.fillWidth: true
                elide: Text.ElideRight
            }

            Text {
                text: body
                color: Theme.textPrimary
                font.pixelSize: 10

                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
    }
}
