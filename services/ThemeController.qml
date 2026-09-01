pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel // Fornece escaneamento nativo ultra rápido de diretórios

QtObject {
    id: controller

    // --- PROPRIEDADES DE CAMINHO DINÂMICAS ---
    readonly property string homeDir: Quickshell.env("HOME")
    readonly property string themeDir: homeDir + "/.config/hypr/themes"
    readonly property string thumbDir: homeDir + "/.cache/hypr_theme/thumbs"
    readonly property string scriptPath: homeDir + "/workspace/quickshell/my-notchqs/scripts/theme_worker.sh"
    
    // --- ESTADO DO GERENCIADOR ---
    property string currentTheme: ""
    property bool isApplying: workerProcess.running

    // --- PROCESSO ASSÍNCRONO BASH ---
    property var workerProcess: Process {
        command: ["sh", controller.scriptPath, "apply", ""]

        onExited: (exitCode) => {
            if (exitCode === 0) {
                console.log("Tema aplicado com sucesso.")
                controller.updateCurrentTheme()
            } else {
                console.error("Erro ao aplicar tema. Código:", exitCode)
            }
            running = false
        }
    }

    // --- MODELO DE DADOS DAS THUMBS ---
    // Vasculha a pasta de temas para listar as pastas dinamicamente
    property var themeModel: FolderListModel {
        folder: "file://" + controller.themeDir
        showDirs: true
        showFiles: false
        showDotAndDotDot: false
        sortField: FolderListModel.Name
    }

    // --- FUNÇÕES DE CONTROLE ---

    // Executa a inicialização (Gera Thumbs que faltam)
    function initialize() {
        console.log("Inicializando Themecontroller e verificando miniaturas...")
        var initProcess = Qt.createQmlObject('import Quickshell.Io; Process {}', controller)
        initProcess.command = ["sh", controller.scriptPath, "generate_thumbs"]
        initProcess.running = true
        controller.updateCurrentTheme()
    }

    // Aplica o tema selecionado
    function applyTheme(themeName: string) {
        if (controller.isApplying) return
        
        console.log("Solicitando aplicação do tema:", themeName)
        workerProcess.command = ["sh", controller.scriptPath, "apply", themeName]
        workerProcess.running = true
    }

    // Lê qual o tema atual salvo no cache
    function updateCurrentTheme() {
        // 🌟 CORREÇÃO: No Quickshell usa-se o FileView
        var fileView = Qt.createQmlObject('import Quickshell.Io; FileView { blockLoading: true }', controller)
        fileView.path = controller.homeDir + "/.cache/hypr_theme/current_theme"
        
        // O FileView carrega o conteúdo direto na propriedade .text
        if (fileView.text()) {
            controller.currentTheme = fileView.text().trim()
            console.log("Tema atualizado no QML para:", controller.currentTheme)
        } else {
            console.log("Aviso: Arquivo de cache de tema vazio ou inexistente.")
        }
        
        // Destrói o componente temporário para liberar memória
        fileView.destroy()
    }

    // Executa a leitura ao carregar o componente
    Component.onCompleted: {
        controller.initialize()
    }
}
