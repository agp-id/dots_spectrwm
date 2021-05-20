#!/usr/bin/env sh

## Just user
[ $(id -u) = 0 ] && echo "DON'T run as root !" && exit

## Force exit
trap exit SIGINT

## Prefer doas
if [ $(command -v doas) ];then
  su='doas'
else
  su='sudo'
fi

## Colors:
normal=$(tput sgr0)
bold=$(tput bold)
red=$(tput setaf 1)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
blue=$(tput setaf 4)
purple=$(tput setaf 5)

## WARNING!
echo -e $red$bold"\n >>> DWYOR <<<
DON'T just run!"
echo $yellow":: continue?$normal$bold [y/N]"$normal
read -p "" yn
  case $yn in
      [yY]* ) ;;
      * ) echo -e "Bye ;)\n" && sleep 1 && exit;;
  esac


##=========================================================================================
##--------------------------------------------------------------- error & exit
error (){
  echo $red"\n===============| ERROR ! |==============$normal
  Sorry for error[s] ;')\n"

  exit 1
}

##--------------------------------------------------------------- Check/install STOW
install_stow (){
  echo -e $blue$bold"=======================================|STOW package check"$normal && sleep 2
  if [ $(command -v stow) ]; then
    echo -e $green"----------------------|Installed\n"$normal
  else
    echo -e $purple"----------------------|Installing\n"$normal
    $su pacman -S --noconfirm --needed stow || error
    install_stow
  fi
  sleep 1
  echo -e $purple$bold"=======================================|Start STOW-ing"$normal && sleep 2
}

##--------------------------------------------------------------- Check dir / file
check (){
  echo -e ""
  for n in $@; do
    if [ -L $n ];then
      echo "unLINK: $n"
      unlink $n
    elif [ -f $n ] || [ -d $n ];then
      rm -rfv $n
    else
      echo "no symlink/file/dir:  $n"
    fi
  done
  echo ""
}

##--------------------------------------------------------------- Create dir (unstow)
makedir (){
  for n in $@; do
    if [ ! -d $n ];then
      mkdir -pv $n
    fi
  done
  echo ""
}



##=========================================================================== Stow home (~)
home (){
  echo -e $yellow"----------------------|Home (~)"$normal
  check \
    ~/.gitconfig \
    ~/.xinitrc

  stow -v home
  sleep 1
}

##--------------------------------------------------------------- Stow .local
scripts (){
  echo -e $yellow"\n----------------------|Script"$normal
  check \
    ~/.local/bin

  stow -v scripts
  sleep 1
}

share (){
  echo -e $yellow"\n----------------------|Local-share"$normal
  check \
    ~/.local/share/applications \
    ~/.local/share/backgrounds \
    ~/.local/share/fonts \
    ~/.local/share/icons \
    ~/.local/share/themes

  makedir \
    ~/.local/share

  stow -v share
  sleep 1
}
##============================================================================ Stow .config
config (){
  echo -e $yellow"\n----------------------|.config"$normal
  check \
    ~/.config/mimeapps.list \
    ~/.config/Trolltech.conf

  makedir ~/.config

  stow -v config
  sleep 1
}

##--------------------------------------------------------------- cava
cava (){
  echo -e $yellow"\n----------------------|Cava"$normal
  check \
    ~/.config/cava

  stow -v cava
  sleep 1
}

##--------------------------------------------------------------- dconf
dconf (){
  echo -e $yellow"\n----------------------|Dconf"$normal
  check \
    ~/.config/dconf

  stow -v dconf
  sleep 1
}

##--------------------------------------------------------------- fish
fish (){
  ##check fish installed
  command -v fish > /dev/null || return

  echo -e $yellow"\n----------------------|Fish"$normal
  echo -e $red":: Remove all file '.*bash*' in home dir ?$normal$bold [Y/n]"$normal
    read -p "" yn
      case $yn in
        * ) rm -rfv ~/.*bash*;;
        [nN]* ) return;;
      esac

  check \
    ~/.config/fish

  makedir \
    ~/.config/fish

  stow -v fish
  fish_root
  sleep 1
}
##------------------ root config
fish_root (){
  echo -e $purple"\n-----------|Root"$normal
  echo -e $red":: Make fish config root sama as user?$normal$bold [Y/n]"$normal
    read -p "" yn
      case $yn in
        * ) $su rm -rfv \
                /root/.config/fish/alias.fish\
                /root/.config/fish/config.fish\
                /root/.config/fish/functions/fish_prompt.fish
            $su mkdir -pv /root/.config/fish/functions
            $su stow -v fish -t /root
            ;;
        [nN]* ) return;;
      esac
  }
##--------------------------------------------------------------- gtk
gtk (){
  echo -e $yellow"\n----------------------|GTK"$normal
  check \
    ~/.config/gtk-*

  makedir \
    ~/.config/gtk-3.0

  stow -v gtk
  sleep 1
}

##--------------------------------------------------------------- htop
htop (){
  echo -e $yellow"\n----------------------|Htop"$normal
  check \
    ~/.config/htop

  stow -v htop
  sleep 1
}

##--------------------------------------------------------------- mpd
mpd (){
  echo -e $yellow"\n----------------------|Mpd"$normal
  check \
    ~/.config/mpd

  makedir \
    ~/.config/mpd

  stow -v mpd
  sleep 1
}

##--------------------------------------------------------------- mpv
mpv (){
  echo -e $yellow"\n----------------------|Mpv"$normal
  check \
    ~/.config/mpv

  stow -v mpv
  sleep 1
}
##--------------------------------------------------------------- ncmpcpp
ncmpcpp (){
  echo -e $yellow"\n----------------------|Ncmpcpp"$normal
  check \
    ~/.config/ncmpcpp

  makedir \
    ~/.config/ncmpcpp

  stow -v ncmpcpp
  sleep 1
}

##--------------------------------------------------------------- nvim
neovim (){
  echo -e $yellow"\n----------------------|Neovim"$normal
  sleep 2
  rm -rf ~/.config/nvim

  makedir \
    ~/.config/nvim/autoload

  stow -v neovim

  echo -e $red"\n:: Update nvim plug-plugin now ?$normal$bold [Y/n]"$normal
    read -p "" yn
      case $yn in
          [nN]* ) echo $red'------------|Skip!'$normal &&return;;
          * ) plug_nvim;;
      esac

  sleep 1
}
plug_nvim (){
  if [ $(command -v nvim) ]; then
    echo
    echo $purple'=========|Updating nvim plugin'$normal
    echo $blue"Please wait..." && sleep 2
    if
      ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
      nvim +PlugUpdate +q +q
      echo
      echo $green'------------|Done'$normal
    else
      echo $red'------------|Skip, no connection!'$normal
    fi
  fi
}

##--------------------------------------------------------------- picom
picom (){
  echo -e $yellow"\n----------------------|Picom"$normal
  check \
    ~/.config/picom

  stow -v picom
  sleep 1
}

##--------------------------------------------------------------- rofi
rofi (){
  echo -e $yellow"\n----------------------|Rofi"$normal
  check \
    ~/.config/rofi

  stow -v rofi
  sleep 1
}

##--------------------------------------------------------------- bspwm
spectrwm (){
  echo -e $yellow"\n----------------------|Bspwm"$normal
  check \
    ~/.config/spectrwm

  stow -v spectrwm
  sleep 1
}

##--------------------------------------------------------------- thunar
thunar (){
  echo -e $yellow"\n----------------------|thunar"$normal
  check \
    ~/.config/Thunar

  stow -v thunar
  sleep 1
}

##--------------------------------------------------------------- xfce
xfce4 (){
  echo -e $yellow"\n----------------------|Xfce4"$normal
  check \
    ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

  makedir ~/.config/xfce4/xfconf/xfce-perchannel-xml

  stow -v xfce4
  sleep 1
}

##--------------------------------------------------------------- wall
wall (){
  echo -e $purple"\n======================|Wallpaper\n"$normal
  echo $yellow":: Stow agp-id colections background ?$normal$bold [Y/n]"$normal
  read -p "" yn
    case $yn in
        * ) wall_2;;
        [nN]* ) echo $red'Skip!' && return;;
    esac

  sleep 1
}

wall_2(){
  if [ ! -d wall ]; then
    echo "======|Downloadin background from agp-id (github)."
    git clone https://github.com/agp-id/wall.git || error
  fi

  check \
    ~/.local/share/backgrounds

  makedir \
    ~/.local/share

  stow -v wall -t ~/.local/share/
}


##=================================================================================== /etc
etc (){
  echo -e $purple"\n=================================|System"$normal
  echo $red$bold"DON'T just run, if you not sure!"
  echo $yellow":: continue?$normal$bold [Y/n]"$normal
  read -p "" yn
    case $yn in
        * ) do_it;;
        [nN]* ) echo $red'Skip!' && return;;
    esac
  }

do_it (){
  $su rm -rfv \
    /etc/X11/xorg.conf.d

  $su mkdir -pv \
    /etc/X11/xorg.conf.d

  $su stow -v etc -t /

  [ -f /etc/pacman.conf ] &&
    $su sed -i --follow-symlinks \
            -e "s/.*Color/Color/" \
            -e "/.*ILove.*/d" \
            -e "/.*Color/a ILoveCandy" \
            -e "s/.*TotalDo.*/TotalDownload/" \
            -e "s/.*VerbosePkgLists/VerbosePkgLists/" \
                /etc/pacman.conf 

  command -v paru >/dev/null &&
    $su sed -i --follow-symlinks \
         -e "s/.*BottomUp/BottomUp/" \
         -e "/.*Sudo.*=.*/d" \
         -e "s/.*\[bin\].*/\[bin\]/" \
         -e "/.*\[bin\].*/a Sudo\ \=\ \/usr\/bin\/doas" \
         /etc/paru.conf


  $su sed -i --follow-symlinks \
          -e '/#start$/,/#end$/d' /etc/hosts
  [ -f hosts ] && cat hosts | $su tee -a /etc/hosts >/dev/null


  printf "======| Ignore PowerButton to shutdown ? [y/N] "
    read yn
      case $yn in
          [Yy]* )
            $su sed -i "s/.*HandlePowerKey.*/HandlePowerKey=ignore/" /etc/elogind/logind.conf
            echo -e $green"---|PowerButton ignored.\nYou can still longress PowerButton to force shutdown"$normal
            ;;
      esac

  sleep 1
}


##=========================================================================================
## Uncomment to stow config, comment to skip
install_stow

##list stow:
home
scripts
share

config
cava
dconf
fish
gtk
htop
mpv
mpd
ncmpcpp
neovim
picom
#rofi
spectrwm
thunar
xfce4

wall

etc

echo "
$bold$blue
 ======================================| FINISH |===========================================
$normal"
