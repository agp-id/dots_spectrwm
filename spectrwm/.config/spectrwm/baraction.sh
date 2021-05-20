#!/usr/bin/env sh
 
#############################
#           BATTERY
#############################
 
bat() {
  batstat="$(cat /sys/class/power_supply/BAT0/status)"
  battery="$(cat /sys/class/power_supply/BAT0/capacity)"
    if [ $batstat = 'Unknown' ]; then
        batstat=""
    elif [[ $battery -ge 5 ]] && [[ $battery -le 19 ]]; then
        batstat=""
    elif [[ $battery -ge 20 ]] && [[ $battery -le 39 ]]; then
        batstat=""
    elif [[ $battery -ge 40 ]] && [[ $battery -le 59 ]]; then
        batstat=""
    elif [[ $battery -ge 60 ]] && [[ $battery -le 79 ]]; then
        batstat=""
    elif [[ $battery -ge 80 ]] && [[ $battery -le 95 ]]; then
        batstat=""
    elif [[ $battery -ge 96 ]] && [[ $battery -le 100 ]]; then
        batstat=""
    fi
 
  echo "$batstat  $battery"%""
}

##############################
#           Brightness
##############################
 
lume() {
        lume="$(xbacklight -get | awk -F'.' 'END{print $1}')"
        echo -e "+@fn=1;+@fn=1; $lume%"
}

########################################
#             DATE & TIME
########################################

clock() {
    _date=$(date '+%a %e %b')
    _time=$(date '+%l:%M %p')
	echo -e "+@fn=2;+@fn=1; $_date+@fn=3;  ┃+@fn=1;$_time"
}

##############################
#           Disk /
##############################

part_root() {
echo "+@fn=2;ﲭ+@fn=1; $(df -h|grep "/$" |awk '{print $4}')"
}

##############################
#           Memory
##############################

mem() {
  echo "+@fn=2;+@fn=1; $(free |grep Mem |awk '{print int($3*100 /$2)}')%"
}

##############################
#           Mpd
##############################

mpd() {
    _title=$(mpc current)
    _time=$(mpc |grep '\[playing\]' | awk '{ print $3 }' | sed 's/[:/]/ /g' |awk '{print ($3*60+$4)-($1*60+$2)}')
    _minute=$((_time/60))
    _second=$((_time%60))
            [[ $_second -lt 10 ]] && _second="0$_second"
    mpc |grep 'random: on' > /dev/null &&
        icon='+@fn=2;+@fn=1;' ||      ## Random: on
        icon='+@fn=2;+@fn=1;'
    
    pgrep mpd > /dev/null && mpc status |grep '\[playing\]' &&
      echo "$icon  [$_minute:$_second] +@fn=3;${_title:0:35}+@fn=1;"
}

########################################
#             NETWORK
########################################
 

rtx() {
    _interface=$(ip route | grep '^default' | awk '{print $5}')

  for a in $_interface; do
    _r=$(cat /sys/class/net/$a/statistics/rx_bytes)
    _t=$(cat /sys/class/net/$a/statistics/tx_bytes)
    echo $_r    $_t
  done
}

netspeed() {
    [[ -z $Rx1 ]] || [[ -z $Tx1 ]] && return

        Rx2=$(rtx |awk '{sum+=$1} END {print sum}')
        Tx2=$(rtx |awk '{sum+=$2} END {print sum}')
        RBps=$((Rx2-Rx1))
        TBps=$((Tx2-Tx1))
        Rxps="$((RBps/1024))"
        Txps="$((TBps/1024))"
        
        RM=$((Rxps/1024))
        Rm=$((Rxps%1024*10/1024))
        TM=$((Txps/1024))
        Tm=$((Txps%1024))

        [[ $Rm -ge 100 ]] && Rm=".$(echo $Rm | cut -c1-1)" || Rm=""
        [[ $Tm -ge 100 ]] && Tm=".$(echo $Tm | cut -c1-1)" || Tm=""

        [[ -n $(ip route | grep '^default' | awk '{print $5}') ]] &&
        if [[ $RM -ge 1 ]]; then
          Rxps="$RM$Rm Mb/s"
          Txps="$TM$Tm Mb/s"
        else
          Rxps="$Rxps kb/s"
          Txps="$Txps kb/s"
        fi
        echo -e "+@fn=1;${Rxps} +@fn=2;+@fn=1; ${Txps}"
}

wifi() {
    interface=$(iwctl device list |awk '/wl/{print $1}'| head -n1)
    wifi=$(ip a | grep $interface | grep inet | wc -l)
    myssid=$(iwctl station $interface show | grep 'Connected '| awk '{print $3}') 
 
    if [ $wifi = 1 ]; then
        echo -e "+@fn=2; +@fn=1;$myssid"
    else 
        echo "+@fn=2;睊+@fn=1; Disconnected"
    fi
}

##############################
#           System Temp
##############################
 
temp() {
    temp="$(sensors | awk '/CPU/ {print $2+0}')"  
    echo -e "+@fn=2;+@fn=1; ${temp}+@fn=2;糖"
}

##############################
#          VOLUME
##############################

vol() {
    VOLONOFF="$(amixer -D pulse get Master | grep Left: | sed 's/[][]//g' | awk '{print $6}')"
    volu="$(amixer -D pulse get Master | awk -F'[][]' 'END{ print $2 }')"
    auJack=$(cat /proc/asound/card0/codec\#0 |grep -A 4 Head |grep "Amp-Out vals:  \[0x80 0x80\]")

    if [[ $auJack == "" ]]; then
        MuteIcon="+@fn=2;ﳌ"
        VolIcon="+@fn=2;" 
    else
        MuteIcon="+@fn=2;婢"
        VolIcon="+@fn=2;墳"        
    fi
        
     
    if [ "$VOLONOFF" = "on" ]; then
        echo "$VolIcon+@fn=1; $volu"
    else
        echo "$MuteIcon+@fn=1; Mute"
    fi
}
 
 
#########################################
#        Bar Action Output
#########################################
 
      SLEEP_SEC='0.6'      #loops forever outputting a line every SLEEP_SEC secs
      while :; do     
        echo   "$(mpd)     $(netspeed)  $(wifi)   $(mem)  $(part_root)  $(temp)  $(vol)  $(clock)"    #$(lume)     $(bat)"

        ## netspeed
            Rx1=$(rtx |awk '{sum+=$1} END {print sum}')
            Tx1=$(rtx |awk '{sum+=$2} END {print sum}')

            sleep $SLEEP_SEC
        done
