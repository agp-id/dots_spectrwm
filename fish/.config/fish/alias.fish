## multi alias
function aliass
   for a in $argv
       alias $a
   end
end

#Prefer doas
if [ (command -v doas) ]
   alias sudo='doas'
end


#terminal
alias st-256color 'st'

#vim/nvim
if command -q nvim
  alias vim nvim
  alias vimdiff 'nvim -d'
end
alias e $EDITOR

#exit terminal
alias :q exit

# ls to lsd
aliass\
   la=ls\
   ls='lsd -A'\
   ll="lsd -Al --total-size --date '+%d/%m/%Y %H:%M'"

# Verbosity and settings that you pretty much just always are going to want.
aliass\
    cp='cp -iv'\
    mv='mv -iv'\
    rm='rm -r'\
   mkd='mkdir -pv'

# Colorize commands when possible.
aliass\
    grep='grep --color=auto'\
   egrep='egrep --color=auto'\
   fgrep='fgrep --color=auto'\
    diff='diff --color=auto'\
    ccat='highlight --out-format=ansi'\
      ip='ip -c'

# Pacman / paru
aliass\
    pacman='paru'\
        up='paru -Syyu'\
     upall='paru -Syu --noconfirm'\
    unlock='sudo rm /var/lib/pacman/db.lck'\
  paruskip='paru -S --mflags --skipinteg'\
   cleanup="sudo pacman -Rns (pacman -Qtdq)"

# Update mirror
alias mirror-update 'sudo reflector --verbose --latest 5 --protocol http,https --sort rate --save /etc/pacman.d/mirrorlist-arch'

# Switch between bash and fish
alias	tobash "sudo chsh $USER -s /bin/bash; and echo 'Now log out.'"
alias	tofish "sudo chsh $USER -s /bin/fish; and echo 'Now log out.'"

# Shutdown or reboot
alias	poweroff 'loginctl poweroff -i'
alias	reboot 'loginctl reboot -i'

# These common commands are just too long! Abbreviate them.
aliass\
       ka='killall'\
        g='git'\
   ps_mem='sudo ps_mem'\
      rsm='sudo rsm'

# Youtube-dl
aliass\
      yt-aac="youtube-dl --extract-audio --audio-format aac"\
     yt-best="youtube-dl --extract-audio --audio-format best"\
     yt-flac="youtube-dl --extract-audio --audio-format flac"\
      yt-mp3="youtube-dl --extract-audio --audio-format mp3 --add-metadata --embed-thumbnail"\
     yt-opus="youtube-dl --extract-audio --audio-format opus"\
   yt-vorbis="youtube-dl --extract-audio --audio-format vorbis"\
      yt-wav="youtube-dl --extract-audio --audio-format wav"\
    ytv-best="youtube-dl -f bestvideo+bestaudio"

#alias	merge "xrdb -merge ~/.config/Xresources"
aliass\
          free="free -mt"\
     microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'\
     update-fc='sudo fc-cache -fv'\
   update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

