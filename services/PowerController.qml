pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: controller

    property Component cmdRunner: Component {
        Process {
            id: proc
            onExited: proc.destroy()
        }
    }

    function runCommand(cmdList: var): void {
        let process = controller.cmdRunner.createObject(controller, { command: cmdList })
        process.running = true
    }

    function powerOff(): void {
        runCommand(["systemctl", "poweroff"])
    }
    function lock(): void {
        runCommand(["hyprlock"])
    }
    function suspend(): void {
        runCommand(["systemctl", "suspend"])
    }
    function reboot(): void {
        runCommand(["systemctl", "reboot"])
    }
    function logout(): void {
        runCommand(["hyprctl", "dispatch", "'hl.dsp.exit()'"])
    }
}