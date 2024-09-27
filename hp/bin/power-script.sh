
#!/bin/bash


# Define options with Nerd Font icons
options=" Lock\n Logout\n Reboot\n Shutdown"

# Show the rofi menu with the specified font
chosen="$(echo -e "$options" | rofi  -dmenu -i -p "Power Menu:" -font "JetBrainsMono Nerd Font Medium 16.5" )"


# Function to confirm action with buttons (Yes/No), defaulting to "No"
confirm_action() {
    rofi -dmenu -i -p "Are you sure?" -mesg "Select 'Yes' to confirm." -markup-rows -font "JetBrainsMono Nerd Font Medium 16.5"  <<< $' No\n Yes'
}

# Take action based on the selected option
case $chosen in
    *Lock*)
        betterlockscreen -l blur ;;
    *Logout*)
        confirm=$(confirm_action)
        if [[ $confirm == *Yes* ]]; then
            killall i3
        fi ;;
    *Reboot*)
        confirm=$(confirm_action)
        if [[ $confirm == *Yes* ]]; then
            systemctl reboot
        fi ;;
    *Shutdown*)
        confirm=$(confirm_action)
        if [[ $confirm == *Yes* ]]; then
            systemctl poweroff
        fi ;;
    *)
        exit 1 ;;
esac

