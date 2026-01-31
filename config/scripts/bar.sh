#!/bin/bash

interval=0

# load colors
. ~/.config/adalc/sexy_kasugano

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
  printf "^c$white^ 󰇅"
  printf "^c$white^ $cpu_val"
}

battery() {
  val="$(cat /sys/class/power_supply/BAT1/capacity)"
  printf "^c$black^ ^b$red^ BAT"
  printf "^c$white^ ^b$grey^ $val ^b$black^"

}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$white^  "
  printf "^c$white^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/en*/operstate 2>/dev/null)" in
	up) printf "^c$white^ 󰤨 ^d^%s" " ^c$green^Connected" ;;
	down) printf "^c$white^ 󰤭 ^d^%s" " ^c$red^Disconnected" ;;
	esac
}

clock() {
	printf "^c$white^ ^b$darkblue^ 󱑆 "
	printf "^c$white^^b$blue^ $(date '+%Y %b %d | %H:%M')  "
}

keymap(){
  printf "^c$white^ ⌨ $(setxkbmap -query | awk '/layout/{print $2}')"
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(keymap) $(cpu) $(mem) $(wlan) $(clock)"
done
