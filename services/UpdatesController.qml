pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: controller

    property string text: ""
    property string alt: "" // 'has-updates' ou 'updated'
    property string tooltipText: ""
    property bool hasUpdates: alt === "has-updates"

    property var updateProcessCommand: Process {
        command: ["kitty", "--class", "update-floating", "-e", "update"]
        
    }

    property var updateProcess: Process {
        command: [
            "waybar-module-pacman-updates", 
            "--interval-seconds", "5", 
            "--network-interval-seconds", "7200"
        ]
        
        stdout: SplitParser {
            onRead: (line) => {
                if (!line.trim()) return;
                
                try {
                    let data = JSON.parse(line);
                    let newText = data.text || "";
                    let newAlt = data.alt || "";

                    // ✅ Só atualiza e executa a lógica se os dados realmente mudarem
                    if (controller.text !== newText || controller.alt !== newAlt) {
                        controller.text = newText;
                        controller.alt = newAlt;
                        controller.tooltipText = data.tooltip || "";
                    }
                } catch (e) {
                    console.error("Erro ao processar JSON do pacman updates:", e);
                }
            }
        }
    }

    function update(): void {
        updateProcessCommand.running = true
    }
}