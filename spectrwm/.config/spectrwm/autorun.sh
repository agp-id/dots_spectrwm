#!/usr/bin/env sh

feh --no-fehbg --randomize --bg-fill ~/.local/share/backgrounds/ &
picom & #--config ~/.config/picom/picom.conf &
xsetroot -cursor_name left_ptr &
sleep 1 && /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
xset r rate 300 50 &	# Speed xrate up
unclutter &		# Remove mouse when idle

