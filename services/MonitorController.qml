pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int cpuUsage: 0
    property int ramUsage: 0
    property string cpuColor: ''
    property string ramColor: ''

    property int timerInterval: 2500

    property real lastTotalTime: 0
    property real lastIdleTime: 0

    property var cpuStatFile: FileView {
        path: "/proc/stat"
    }

    property var memInfoFile: FileView {
        path: "/proc/meminfo"
    }

    property var timer: Timer {
        interval: root.timerInterval
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.updateRam()
            root.updateCpu()
        }
    }

    function updateRam() {
        memInfoFile.reload()
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

    function updateCpu() {
        cpuStatFile.reload()
        let text = cpuStatFile.text()
        if (!text) return

        let firstLine = text.split("\n")[0] // Pega a linha principal "cpu  ..."
        let times = firstLine.trim().split(/\s+/).slice(1).map(Number)

        if (times.length < 4) return

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

    property var btopProcess: Process {
        command: ["kitty", "--class", "btop-floating", "-e", "btop"]
    }

    function openBtop() {
        btopProcess.running = true
    }
}
