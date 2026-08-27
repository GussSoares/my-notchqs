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
        id: notifServer

        onNotification: (notification) => {
            if (!notification) return;

            let exists = activeNotifications.some(n => n.id === notification.id)
            if (exists) return;

            let notifData = Object.assign({}, notification, { rawNotification: notification });

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
        if (!notification) return
        
        // Se passarem o objeto JS customizado, pega a notificação nativa interna
        let raw = notification.rawNotification ? notification.rawNotification : notification

        removeNotification(raw)
        
        if (raw && typeof raw.dismiss === "function") {
            raw.dismiss()
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

    function launch(notification) {
        if (!notification) return

        let raw = notification.rawNotification ? notification.rawNotification : notification
        
        // 1. Diz ao aplicativo de origem para abrir o chat correspondente
        if (raw && typeof raw.activateAction === "function") {
            raw.activateAction("default")
        }

        let appQuery = (notification.desktopEntry !== "" ? notification.desktopEntry : notification.appName).toLowerCase()

        // 2. Cria um processo rápido para ler as janelas ativas do Hyprland em formato JSON
        let clientProc = cmdRunner.createObject(controller, { command: ["hyprctl", "clients", "-j"] });
        clientProc.running = true;

        // Aguarda a resposta do terminal
        // let targetClient = null;
        // let output = clientProc.readAllString(); // Captura o JSON gerado pelo hyprctl
        // clientProc.destroy();

        // if (output && output.trim() !== "") {
        //     try {
        //         let clientsList = JSON.parse(output);
                
        //         // Varre a lista real de janelas devolvida pelo compositor
        //         for (let i = 0; i < clientsList.length; i++) {
        //             let client = clientsList[i];
        //             let clientClass = (client.initialClass || client.class || "").toLowerCase();
                    
        //             if (clientClass.includes(appQuery) || appQuery.includes(clientClass)) {
        //                 targetClient = client;
        //                 break;
        //             }
        //         }
        //     } catch (e) {
        //         console.log("Erro ao processar JSON de clientes do Hyprland:", e);
        //     }
        // }

        // // 3. Se encontramos a janela aberta, focamos usando o endereço
        // if (targetClient && targetClient.address) {
        //     Hyprland.dispatch(`hl.dsp.focus({ window = "address:${targetClient.address}" })`)
        // } else {
        //     // 4. Se o app não estava aberto, inicia ele do zero
        //     launchFromNotification(notification)
        // }

        // // 5. Descarta a notificação visualmente após o clique
        // dismiss(notification)
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
                    console.log(this.data)
                    console.log(this.data[0].class)
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