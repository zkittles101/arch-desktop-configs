#!/usr/bin/env bash

# set the icon and a temporary location for the screenshot to be stored
# icon="$HOME/images/lock-icon-light.png"
tmpbg='/tmp/screen.png'

# Delete the previous screenshot if it exists
if [ -f "$tmpbg" ]; then
    rm "$tmpbg"
    echo "Previous screenshot deleted."
fi

# take a screenshot
scrot "$tmpbg"

# blur the screenshot by resizing and scaling back up
convert "$tmpbg" -filter box -thumbnail 20% -sample 500% "$tmpbg"

# overlay the icon onto the screenshot
# convert "$tmpbg" "$icon" -gravity center -composite "$tmpbg"

# lock the screen with the blurred screenshot
i3lock -i "$tmpbg"

