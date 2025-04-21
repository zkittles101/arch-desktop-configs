alias nnn="nnn -c"

# nnn configuration
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='v:preview-tui'
export NNN_BMS='c:~/.config;m:/mnt/DaBox/Markdown-Notes;D:~/Downloads/'

export NNN_OPENER=/home/e/.config/nnn/plugins/nuke
