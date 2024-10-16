#!/bin/bash

# Paths to TLP config folders
TLP_CONFIG_DIR="$HOME/tlp-configs"
TLP_CONF_PATH="/etc/tlp.conf"

# Check the currently active TLP mode by comparing config files
if diff "$TLP_CONF_PATH" "$TLP_CONFIG_DIR/balanced/tlp.conf" >/dev/null; then
    CURRENT_MODE="Balanced"
elif diff "$TLP_CONF_PATH" "$TLP_CONFIG_DIR/powersave/tlp.conf" >/dev/null; then
    CURRENT_MODE="Powersave"
elif diff "$TLP_CONF_PATH" "$TLP_CONFIG_DIR/performance/tlp.conf" >/dev/null; then
    CURRENT_MODE="Performance"
else
    CURRENT_MODE="Unknown"
fi

# Rofi options with Nerd Font icons
OPTIONS=$(echo -e " Balanced\n Powersave\n Performance")

# Show Rofi menu and get selected option
SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -p " Choose Power Mode [ Current: $CURRENT_MODE ] " -theme-str 'window {height:225px;}')

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
    *Performance*)
        sudo cp "$TLP_CONFIG_DIR/performance/tlp.conf" "$TLP_CONF_PATH"
        sudo tlp start # Apply TLP settings
        notify-send "Power Mode" "Performance mode activated" -i battery
        ;;
    *)
        notify-send "Power Mode" "No valid option selected." -i battery
        exit 1
        ;;
esac

