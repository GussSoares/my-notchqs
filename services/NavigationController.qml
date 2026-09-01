pragma Singleton
import QtQuick
import Quickshell

QtObject {
    id: controller

    enum Views {
        Clock,
        NotchExpanded,
        ControlCenter,
        Monitor,
        Volume,
        Brightness,
        Notification,
        Music,
        PowerMenu,
        ThemeSelector
    }

    enum IpcViews {
        PowerMenu=8,
        ThemeSelector=9
    }

    property int currentView: 0

    function navigate(value: int) {
        controller.currentView = value
    }
}
