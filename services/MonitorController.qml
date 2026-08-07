pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: controller

    property var btopProcess: Process {
        command: ["kitty", "--class", "btop-floating", "-e", "btop"]
    }

    function openBtop() {
        btopProcess.running = true
    }
}