import QtQuick
import QtQuick.Layouts
import "../services"

Item {
    id: root
    width: mainLayout.implicitWidth
    height: 400

    ColumnLayout {
        spacing: 8

        Notification {idd: 1}
        Notification {idd: 2}
        Notification {idd: 3}
        Notification {idd: 4}
        Notification {idd: 5}
    }

}
