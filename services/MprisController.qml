// services/MprisController.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

QtObject {
    id: controller

    // Seleciona o primeiro player disponível ou o que estiver tocando
    readonly property MprisPlayer activePlayer: Mpris.players.values[0] ?? null

    // Propriedades expostas
    readonly property bool hasPlayer: activePlayer !== null
    readonly property string trackTitle: activePlayer?.trackTitle ?? "Nenhuma mídia"
    readonly property string trackArtist: activePlayer?.trackArtist ?? "Desconhecido"
    readonly property string trackAlbum: activePlayer?.trackAlbum ?? ""
    
    // URL da capa da música (Thumb/ArtUrl)
    readonly property string artUrl: activePlayer?.trackArtUrl ?? ""
    
    // Estado de reprodução
    readonly property bool isPlaying: activePlayer?.playbackState === MprisPlaybackState.Playing

    // Ações de Controle
    function togglePlayPause() {
        if (activePlayer && activePlayer.canControl) {
            activePlayer.togglePlaying()
        }
    }

    function next() {
        if (activePlayer && activePlayer.canGoNext) {
            activePlayer.next()
        }
    }

    function previous() {
        if (activePlayer && activePlayer.canGoPrevious) {
            activePlayer.previous()
        }
    }
}
