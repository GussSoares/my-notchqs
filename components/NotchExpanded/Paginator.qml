import QtQuick
import QtQuick.Layouts
import "../../"

Item {
    id: root

    property int page: 1
    readonly property string pageSelected: Theme.textSecondary

    Layout.alignment: Qt.AlignHCenter
    Layout.bottomMargin: 10

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent


        Repeater {
            model: 2
            
            Rectangle {
                width: 10
                height: 10
                radius: 5
                color: index + 1 === page ? Theme.textSecondary : Theme.border
            }
        }
    }
}
