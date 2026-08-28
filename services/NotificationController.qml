// services/NotificationController.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Io
import Quickshell.Hyprland

QtObject {
    id: controller

    readonly property int count: activeNotifications.length
    readonly property var notifications: activeNotifications
    property var activeNotifications: []
    property var lastNotification: null
    signal newNotification(var notification)

    property NotificationServer server: NotificationServer {
        actionsSupported: true

        onNotification: (notification) => {
            if (!notification) return;

            notification.tracked = true; 
            let exists = activeNotifications.some(n => n.id === notification.id)
            if (exists) return;

            let notifData = {
                id: notification.id,
                image: notification.image,
                body: notification.body,
                summary: notification.summary
            }

            let list = [notifData, ...controller.activeNotifications]
            controller.activeNotifications = list

            controller.lastNotification = notifData
            controller.newNotification(notifData)

            notification.closed.connect(() => {
                controller.removeNotification(notification)
            })
        }
    }

    function removeNotification(notification) {
        if (!notification) return
        
        // Trata remoção tanto se passarem o ID, o objeto nativo ou o objeto JS
        let notifId = typeof notification === "object" ? notification.id : notification
        activeNotifications = activeNotifications.filter(n => n.id !== notifId)

        // Se a notificação removida for a última exibida, limpa o lastNotification
        if (lastNotification && lastNotification.id === notifId) {
            lastNotification = null
        }
    }

    function dismiss(notification) {
        if (!notification) return;
        
        let notifId = typeof notification === "object" ? notification.id : notification;
        removeNotification(notifId);
        
        if (notification && typeof notification.dismiss === "function") {
            notification.dismiss();
        }
    }

    function clearAll() {
        let list = [...activeNotifications]
        for (let notif of list) {
            dismiss(notif)
        }
        activeNotifications = []
        lastNotification = null
    }


    /////////////////////////////
    function launchFromNotification(notifData): void {
        if (!notifData) return;

        let desktopEntry = notifData.desktopEntry || "";
        let appName = notifData.appName || "";

        // Tenta disparar usando o desktopEntry (ex: "org.telegram.desktop")
        if (desktopEntry !== "") {
            // Remove a extensão .desktop se ela vier junta
            let cleanId = desktopEntry.replace(".desktop", "");
            
            // Dispara via gtk-launch nativo do sistema
            runProcess(["gtk-launch", cleanId]);
            return;
        }

        // Fallback: se não tiver desktopEntry, usa comando direto via appName
        let cmd = resolveFallbackCommand(appName.toLowerCase());
        if (cmd !== "") {
            runProcess([cmd]);
        }
    }

    function launch(notificationId) {
        let notification = server.trackedNotifications.values.find(n => n.id === notificationId)
        if (!notification) return;

        notification.actions[0].invoke()
    }

    function runProcess(cmdList: var): void {
        let process = cmdRunner.createObject(controller, { command: cmdList });
        process.running = true;
    }

    function resolveFallbackCommand(name: string): string {
        if (name.includes("telegram")) return "telegram-desktop";
        if (name.includes("discord") || name.includes("discord")) return "discord";
        if (name.includes("spotify")) return "spotify";
        if (name.includes("firefox")) return "firefox";
        return name;
    }

    property Component cmdRunner: Component {
        Process {
            id: proc
            onExited: proc.destroy()
            stdout: StdioCollector {
                onStreamFinished: (text, data) => {
                    // console.log(Quickshell.execDetached(["hyprctl", "clients", "-j"]))
                    // console.log(this.data)
                    // console.log(this.data[0].class)
                    // try {
                    //     // Converte o texto recebido em um objeto JavaScript
                    //     let clients = JSON.parse(text);
                    //     console.log("Total de janelas abertas: " + clients.length);
                        
                    //     // Exemplo: Iterar pelas janelas
                    //     for (let client of clients) {
                    //         console.log(`Janela: ${client.title} (Classe: ${client.class})`);
                    //     }
                    // } catch (e) {
                    //     console.error("Erro ao processar o JSON: " + e.message);
                    // }
                }
            }
        }
    }
}