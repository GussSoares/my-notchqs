#!/bin/bash

# --- CONFIGURAÇÃO ---
THEME_DIR="$HOME/.config/hypr/themes"
CACHE_DIR="$HOME/.cache/hypr_theme"
THUMB_DIR="$CACHE_DIR/thumbs"
SUPERFILE_CONFIG="$HOME/.config/superfile/config.toml"
VSCODIUM_SETTINGS_JSON="$HOME/.config/VSCodium/User/settings.json"
THUMB_SIZE="220x120"

ACTION=$1
CHOICE=$2

mkdir -p "$THUMB_DIR"

# AÇÃO 1: GERAR MINIATURAS (Executado uma vez no boot do Quickshell)
if [ "$ACTION" = "generate_thumbs" ]; then
    for d in "$THEME_DIR"/*/; do
        [ -d "$d" ] || continue
        THEME_NAME=$(basename "$d")
        WALL=$(find "$d" -type f \( -name "*.jpg" -o -name "*.png" \) | head -n 1)
        
        if [ ! -f "$THUMB_DIR/$THEME_NAME.png" ] && [ -f "$WALL" ]; then
            magick "$WALL" -strip -thumbnail "$THUMB_SIZE^" -gravity center -extent "$THUMB_SIZE" "$THUMB_DIR/$THEME_NAME.png"
        fi
    done
    exit 0
fi

# AÇÃO 2: APLICAR O TEMA SELECIONADO NA GRID QML
if [ "$ACTION" = "apply" ]; then
    [ -z "$CHOICE" ] && exit 1
    THEME_PATH="$THEME_DIR/$CHOICE"

    # Links de Configuração Básicos
    ln -sf "$THEME_PATH/waybar.css" "$HOME/.config/waybar/theme.css"
    ln -sf "$THEME_PATH/wofi.css" "$HOME/.config/wofi/style.css"
    ln -sf "$THEME_PATH/hyprland.lua" "$HOME/.config/hypr/theme.lua"
    ln -sf "$THEME_PATH/swaync.css" "$HOME/.config/swaync/theme.css"
    ln -sf "$THEME_PATH/qs.qml" "$HOME/workspace/quickshell/my-notchqs/Theme.qml"

    # VSCodium Mapping
    case $CHOICE in
        "catppuccin-macchiato")     THEME="Catppuccin Macchiato" ;;
        "catppuccin-mocha")         THEME="Catppuccin Mocha" ;;
        "catppuccin-latte")         THEME="Catppuccin Latte" ;;
        "catppuccin-frappe")        THEME="Catppuccin Frappé" ;;
        "gruvbox")                  THEME="Gruvbox Dark Soft" ;;
        "rose-pine")                THEME="Rosé Pine Moon" ;;
        "tokyo-night")              THEME="Tokyo Night Storm" ;;
        *)                          THEME="Default" ;;
    esac
    if [ -f "$VSCODIUM_SETTINGS_JSON" ]; then
        sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$THEME\"/" "$VSCODIUM_SETTINGS_JSON"
    fi

    # Wallpaper Swww Animado
    WALL=$(find "$THEME_PATH" -type f \( -name "*.jpg" -o -name "*.png" \) | head -n 1)
    if [ -f "$WALL" ]; then
        awww img "$WALL" --transition-type grow --transition-pos "$(hyprctl cursorpos | tr -d ' ')" --transition-fps 144
    fi

    # Kitty Terminal Live Reload
    if [ -f "$THEME_PATH/kitty.conf" ]; then
        ln -sf "$THEME_PATH/kitty.conf" "$HOME/.config/kitty/theme.conf"
        kill -USR1 $(pidof kitty) 2>/dev/null
    fi

    # Superfile (spf) Live Reload
    if [ -f "$THEME_PATH/superfile.toml" ]; then
        sed -i "s/^theme =.*/theme = \"$CHOICE\"/" "$SUPERFILE_CONFIG"
        if pidof spf >/dev/null; then
            kill $(pidof spf) 2>/dev/null
            kitty --class files-floating -e spf &
        fi
    fi

    # Configurações de Temas GTK via GSettings
    if [ -f "$THEME_PATH/settings.ini" ]; then
        GTK_THEME=$(grep "gtk_theme" "$THEME_PATH/settings.ini" | cut -d'=' -f2)
        COLOR_SCHEME=$(grep "color_scheme" "$THEME_PATH/settings.ini" | cut -d'=' -f2)
        ICON_THEME=$(grep "icon_theme" "$THEME_PATH/settings.ini" | cut -d'=' -f2)
        
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
        gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
        gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
    fi

    # Atualiza Status das Barras do Sistema
    # killall -SIGUSR2 waybar 2>/dev/null
    # swaync-client -rs 2>/dev/null

    # Salva Cache e Notifica o usuário
    echo "$CHOICE" > "$CACHE_DIR/current_theme"
    notify-send "Rice Switcher" "Ambiente $CHOICE aplicado." -i "$THUMB_DIR/$CHOICE.png"
    exit 0
fi
