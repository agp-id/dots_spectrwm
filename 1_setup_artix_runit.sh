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

clear # needed before run _lines
_lines(){
   printf $blue$bold
   printf "%-${COLUMNS}s" | sed 's/ /-/g'
   [ -n "$1" ] && {
      printf "%-$(( ($COLUMNS-${#1})/2 ))s"; echo $1
      printf "%-${COLUMNS}s\n" | sed 's/ /-/g'
      sleep 1 &&  :
    }
   printf $normal
}

##========================================================================================
##------------------------------------------------------------------------Install PARU
check_paru (){
  echo $yellow'============================|PARU package'
  if [ $(command -v paru) ]; then
    echo $green'----------------|Installed'$normal

    echo -e "\n==> Pacman Config"
    $su sed -i --follow-symlinks \
            -e "s/.*Color/Color/" \
            -e "/.*ILove.*/d" \
            -e "/.*Color/a ILoveCandy" \
            -e "s/.*TotalDo.*/TotalDownload/" \
            -e "s/.*VerbosePkgLists/VerbosePkgLists/" \
                /etc/pacman.conf
    echo -e "==> Paru config\n"
    $su sed -i --follow-symlinks \
         -e "s/.*BottomUp/BottomUp/" \
         -e "/.*Sudo.*=.*/d" \
         -e "s/.*\[bin\].*/\[bin\]/" \
         -e "/.*\[bin\].*/a Sudo\ \=\ \/usr\/bin\/doas" \
         /etc/paru.conf
    return

  else
    echo $purple'----------------|Installing'$normal
    rm -rf paru-bin
    git clone https://aur.archlinux.org/paru-bin.git || error
    cd paru-bin
    makepkg PKGBUILD
    $su pacman -U --noconfirm paru-bin* || {
      echo "User not allowed use $su, check your config!"
      exit
      }
    cd ../
    rm -rf paru-bin 
 
    check_paru
  fi
}
##------------------------------------------------------------------------Install packages
install_pkg (){
  _lines '[1] Install packages'

  if [ -f pkg.list ]; then
    echo
    check_paru
    paru -Sy --needed --noconfirm
  else
    echo $red'==========|File pkg.list not found.'$normal
    exit
  fi
  paket=$(sed 's/[ /#~].*//;/./!d' pkg.list)
  paru -S --needed --noconfirm $paket || error

  echo -e $yellow"\n====================|Cleanup"$normal
  [ "$(pacman -Qtdq)" == "" ] || $su pacman -Runs $(pacman -Qtdq)

  echo -e $yellow"\n====================|Enable services(runit)"$normal
  s_runit
}

##-----------------------------------------------------------------Enable services (runit)
s_runit (){
  srv="/etc/runit/sv/"
  ln_to="/run/runit/service/"
  i_nit="iwd dhcpcd cupsd ntpd"

  for sr in $i_nit;
   do
    [ -d "$srv$sr" ] && [ ! -L "$ln_to$sr" ] &&
      $su ln -s "$srv$sr" "$ln_to"
   done
}
##------------------------------------------------------------------Instal simple-terminal
install_st (){
  _lines '[2] Install Simple-Terminal'

  echo $blue'-----------|Downloading agp-id(git)'
  cd ../
  if
    [ -d st.old ]; then
    rm -rf st
  elif
    [ -d "st" ] ; then
    echo $yellow'Backup st folder --> st.old'
    mv st st.old
  fi

  echo
  echo $purple'-----------|Installing'$normal
  git clone https://github.com/agp-id/st || error
  cd st
  if [  $(command -v st) ]; then
    $su make clean uninstall
    $su make clean install
  else
    $su make clean install
  fi
  echo
  echo $green'-----------|Done'
}
##-----------------------------------------------------------------------------Fish shell
fish_shell (){
  _lines '[3] Enable "FISH-shell"'

  fis=$(command -v fish)
  if [ $fis ]; then
    echo $yellow'------------|user'$normal
    chsh -s $fis
    echo
    echo $red'------------|root'$normal
    $su chsh -s $fis
  else
    echo $red'=========|FISH not installed.'
  fi
}
##------------------------------------------------------------------------------Autologin
auto_login (){
  _lines '[4] Autologin'

  echo $blue"========|Check runit-init..."$normal
  strings /sbin/init | grep runit > /dev/null || {
    echo $red"---|No runit-init, Skip!"$normal
    return
  }
  echo $yellow
  printf "======| Autologin $blue$USER$yellow in$green TTY1$yellow ?$normal [Y/n] "
    read yn
      case $yn in
          * )
            $su sed -i "s/GETTY_ARGS=\".*\$/GETTY_ARGS=\"--autologin $USER --noclear\"/g" /etc/runit/sv/agetty-tty1/conf
            echo $green"---|Autologin active."$normal
            ;;
          [nN]* )
            $su sed -i "s/GETTY_ARGS=\".*\$/GETTY_ARGS=\"--noclear\"/g" /etc/runit/sv/agetty-tty1/conf
            echo $yellow"---|Autologin inactive."$normal
            ;;
      esac
}
##-----------------------------------------------------------------------------------Stow
stow_config (){
  _lines '[5] Install config (STOW)'

  read -p "::Stow config from Agp ?       [Y/n]"
      case $yn in
          * )
              if [ -f 2_stow_config.sh ]; then
                ./2_stow_config.sh
              else
                echo $red'File "2_stow_config.sh" not found.'$normal
                exit
              fi
            ;;
          [Nn] )
              return
            ;;
      esac

}
##-----------------------------------------------------------------------------------Error
error (){
  echo
  echo $red"===============| ERROR ! |=============="$normal
  exit 1
}
##===========================================================================Functions end




install_pkg
fish_shell
auto_login
stow_config
install_st






#line=$(echo '========================| [5] Install config (STOW) |=======================' | tee /dev/tty)
#printf %s "$line" | tr -c '_' '[_*]'


# '/./!d'         hapus baris kosong
# '/^#/d'         hapus '#' didepan baris
# 's|/$||' 's/[/]$//;'    hapus '/' diakhir baris
# 's/[ /#].*//'   hapus teks sampai akhir baris mulai dari salah satu karakter di dalam "[]", disini " "(spasi) termasuk garis kosong, "/", dan "#"


