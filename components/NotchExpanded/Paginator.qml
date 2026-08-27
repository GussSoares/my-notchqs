import QtQuick
import QtQuick.Layouts
import "../../"

Item {
    id: root

    enum Pages {
        NotchExpanded = 1,
        ControlCenter = 2
    }

    property int page: 1

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

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: NavigationController.navigate(index + 1)
                }
            }
        }
    }
}
