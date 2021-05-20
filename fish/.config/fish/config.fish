# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        dbus-launch startx -- -keeptty
    end
end

#Tombol 'Delete' meghapus karakter dikanan penanda
bind \e\[P 'delete-char'

# Syntax Highlighting Colors
set -g fish_color_normal white
set -g fish_color_command brgreen
set -g fish_color_quote bryellow
set -g fish_color_redirection white
set -g fish_color_end yellow
set -g fish_color_error red
set -g fish_color_param brmagenta
set -g fish_color_comment brblue
set -g fish_color_match --background=black
set -g fish_color_selection --background=black
set -g fish_color_search_match --background=black
set -g fish_color_operator brcyan
set -g fish_color_escape brmagenta
set -g fish_color_autosuggestion brblack

# Completion Pager Colors
set -g fish_pager_color_progress brblue
set -g fish_pager_color_prefix brcyan
set -g fish_pager_color_completion white
set -g fish_pager_color_description brblue
#--------------------------------------------------------------

#Path
if test -e "$HOME/.local/bin"
    set -U fish_user_paths "$HOME/.local/bin"
end

#Default program
command -v st > /dev/null &&
#set -U TERM 'st'
set -Ux TERMINAL 'st'

set -Ux BROWSER 'firefox'
set -Ux READER 'subl3'
set -Ux EDITOR 'nvim'

#alias
. $HOME/.config/fish/alias.fish

#Cleanup ~/
set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_CACHE_HOME "$HOME/.cache"

#app config
set -Ux GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
set -Ux QT_QPA_PLATFORMTHEME "gtk3"	# Have QT use gtk3 theme.
set -Ux TDESKTOP_I_KNOW_ABOUT_GTK_INCOMPATIBILITY "1" #Telegram-desktop gtk
set -Ux MOZ_USE_XINPUT2 "1"		# Mozilla smooth scrolling/touchpads.
set -Ux SXHKD_SHELL '/usr/bin/sh'

sh -c 'rm -r \
    $HOME/.lesshst \
    $HOME/.*_history \
    $HOME/.gore \
    $HOME/.wget-hsts \
    ' > /dev/null 2>&1 &
