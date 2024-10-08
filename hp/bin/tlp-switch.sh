#!/bin/bash

# Paths to TLP config folders
TLP_CONFIG_DIR="$HOME/tlp-configs"
TLP_CONF_PATH="/etc/tlp.conf"

# Rofi options with Nerd Font icons
OPTIONS=$(echo -e " Balanced\n Powersave")

# Show Rofi menu and get selected option
SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -p "Choose Power Mode:" -theme-str 'window {height:200px;}')

# Check selected option and copy corresponding config
case "$SELECTED" in
    *Balanced*)
        sudo cp "$TLP_CONFIG_DIR/balanced/tlp.conf" "$TLP_CONF_PATH"
        sudo tlp start # Apply TLP settings
        notify-send "Power Mode" "Balanced mode activated " -i battery
        ;;
    *Powersave*)
        sudo cp "$TLP_CONFIG_DIR/powersave/tlp.conf" "$TLP_CONF_PATH"
        sudo tlp start # Apply TLP settings
        notify-send "Power Mode" "Powersave mode activated" -i battery
        ;;
    *)
        notify-send "Power Mode" "No valid option selected." -i battery
        exit 1
        ;;
esac

