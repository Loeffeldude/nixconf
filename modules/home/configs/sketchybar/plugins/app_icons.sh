#!/usr/bin/env bash

# App icon mapping using Nerd Font icons
get_app_icon() {
    case "$1" in
        "Arc" | "Firefox" | "Safari" | "Chrome" | "Chromium" | "Brave Browser") echo "" ;;
        "Code" | "Code - Insiders" | "VSCode" | "VSCodium") echo "󰨞" ;;
        "Wezterm" | "Terminal" | "iTerm2" | "Alacritty" | "Kitty") echo "" ;;
        "Slack") echo "󰒱" ;;
        "Discord") echo "󰙯" ;;
        "Spotify") echo "" ;;
        "Music") echo "" ;;
        "Messages" | "Telegram" | "Signal") echo "󰍡" ;;
        "Mail" | "Thunderbird") echo "" ;;
        "Calendar") echo "" ;;
        "Notes" | "Notion") echo "" ;;
        "Finder") echo "" ;;
        "Preview") echo "" ;;
        "System Settings" | "System Preferences") echo "" ;;
        "Docker" | "Docker Desktop") echo "" ;;
        "Obsidian") echo "󱓷" ;;
        "Vim" | "Neovim" | "MacVim") echo "" ;;
        "Emacs") echo "" ;;
        "Zed") echo "󰈺" ;;
        "IntelliJ IDEA" | "PyCharm" | "WebStorm") echo "" ;;
        "Postman") echo "" ;;
        "Figma") echo "" ;;
        "Zoom.us" | "zoom.us") echo "󰊫" ;;
        "Microsoft Teams") echo "󰊫" ;;
        *) echo "" ;;
    esac
}

export -f get_app_icon
