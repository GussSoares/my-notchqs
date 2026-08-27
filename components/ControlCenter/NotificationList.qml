import QtQuick
import QtQuick.Layouts
import "../../services"
import "../../"

Item {
    id: root
    height: listView.count !== 0 ? Math.min(listView.count * 50, 200) : 20

    ListView {
        id: listView
        anchors.fill: parent
        spacing: 8
        clip: true
        visible: listView.count !== 0

        model: NotificationController.activeNotifications.slice(0, 10)

        delegate: Notification {
            required property var modelData
            required property int index
            property int parentWidth: listView.implicitWidth

            notif: modelData
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton 
            propagateComposedEvents: true 

            onWheel: (wheel) => {
                listView.flick(0, wheel.angleDelta.y * 5)
                wheel.accepted = true 
            }
        }
    }

    Text {
        text: 'Nenhuma notificação'
        anchors.centerIn: parent
        color: Theme.textPrimary
        font.pixelSize: 12

        visible: listView.count === 0
    }
}
