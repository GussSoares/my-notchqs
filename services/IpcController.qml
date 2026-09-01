pragma Singleton
import QtQml 2.15
import Quickshell
import Quickshell.Io

// Usamos QtObject porque ele é leve e não tem interface visual
QtObject {
    id: ipcManager

    signal triggerNotchExpanded()
    signal triggerPowerMenu()
    signal triggerThemeSelector()

    property IpcHandler handleNotch: IpcHandler {
        target: "notch"

        function expand(): void {
            ipcManager.triggerNotchExpanded()
        }
    }
    property IpcHandler handlePowerMenu: IpcHandler {
        target: "powerMenu"

        function menu(): void {
            ipcManager.triggerPowerMenu()
        }
    }

    property IpcHandler handleThemeSelector: IpcHandler {
        target: "themeSelector"

        function menu(): void {
            ipcManager.triggerThemeSelector()
        }
    }
}