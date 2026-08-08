import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    id: root
    spacing: 12

    property int cpuUsage: 0
    property int ramUsage: 0

    property real lastTotalTime: 0
    property real lastIdleTime: 0

    FileView {
        id: memInfoFile
        path: "/proc/meminfo"
    }

    FileView {
        id: cpuStatFile
        path: "/proc/stat"
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.updateRam()
            root.updateCpu()
        }
    }

    // --- LÓGICA DA MEMÓRIA RAM ---
    function updateRam() {
        let text = memInfoFile.text()
        if (!text) return

        let memTotal = 0
        let memAvailable = 0

        // Processa cada linha de /proc/meminfo
        let lines = text.split("\n")
        for (let line of lines) {
            if (line.startsWith("MemTotal:")) {
                memTotal = parseInt(line.replace(/[^0-9]/g, ''))
            } else if (line.startsWith("MemAvailable:")) {
                memAvailable = parseInt(line.replace(/[^0-9]/g, ''))
            }
        }

        if (memTotal > 0) {
            let used = memTotal - memAvailable
            root.ramUsage = Math.round((used / memTotal) * 100)
        }
    }

    // --- LÓGICA DA CPU ---
    function updateCpu() {
        let text = cpuStatFile.text()
        if (!text) return

        let firstLine = text.split("\n")[0] // Pega a linha principal "cpu  ..."
        let times = firstLine.trim().split(/\s+/).slice(1).map(Number)

        if (times.length < 4) return

        // Soma dos tempos do processador
        let idle = times[3] + times[4] // idle + iowait
        let total = times.reduce((a, b) => a + b, 0)

        let totalDelta = total - root.lastTotalTime
        let idleDelta = idle - root.lastIdleTime

        if (totalDelta > 0) {
            let cpu = Math.round(((totalDelta - idleDelta) / totalDelta) * 100)
            root.cpuUsage = Math.min(100, Math.max(0, cpu))
        }

        root.lastTotalTime = total
        root.lastIdleTime = idle
    }

    // --- INTERFACE VISUAL DO MÓDULO ---

    // Item da CPU
    RowLayout {
        spacing: 4

        Text {
            text: " " // Ícone FontAwesome ou Nerdfont (opcional)
            color: "#7aa2f7"
            font.pixelSize: 12
        }

        Text {
            text: "CPU " + root.cpuUsage + "%"
            color: root.cpuUsage > 80 ? "#f7768e" : "#c0caf5"
            font.pixelSize: 12
            font.bold: true

            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    // Separador
    Text {
        text: "|"
        color: "#565f89"
        font.pixelSize: 12
    }

    // Item da RAM
    RowLayout {
        spacing: 4

        Text {
            // text: "󰓅 " // Ícone FontAwesome ou Nerdfont (opcional)
            text: {
                if (root.ramUsage < 40) return "󰾆 "
                else if (root.ramUsage >= 40 && root.ramUsage <= 60) return "󰾅 "
                else if (root.ramUsage > 60) return "󰓅 "
            }
            color: "#bb9af7"
            font.pixelSize: 12
        }

        Text {
            text: "RAM " + root.ramUsage + "%"
            color: root.ramUsage > 85 ? "#f7768e" : "#c0caf5"
            font.pixelSize: 12
            font.bold: true

            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }
}
