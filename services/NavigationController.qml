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
        PowerMenu
    }

    property int currentView: 0

    function navigate(value: int) {
        controller.currentView = value
    }
}
