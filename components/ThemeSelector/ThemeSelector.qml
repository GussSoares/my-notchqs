import QtQuick
import QtQuick.Layouts
import "../../services"

Item {
    id: root

    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight + 16

    readonly property var meusElementos: [
        "Item 1", "Item 2", "Item 3", 
        "Item 4", "Item 5", "Item 6", 
        "Item 7"
    ]

    clip: true

    HoverHandler {
        onHoveredChanged: {
            if (!hovered) {
                NavigationController.navigate(NavigationController.Views.Clock)
            }
        }
    }

    Grid {
        id: mainLayout
        anchors.centerIn: parent
        columns: 3 
        spacing: 10

        Repeater {
            model: ThemeController.themeModel

            WallpaperItem {
                theme: model
            }
        }
    }
}