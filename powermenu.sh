#!/bin/bash

CHOICE=$(printf "⏻ Power Off\n Reboot\n🔒 Lock" | fuzzel --dmenu)

case "$CHOICE" in
    *Power\ Off*) systemctl poweroff ;;
    *Reboot*) systemctl reboot ;;
    *Lock*) hyprlock ;; 
    *) exit 1 ;;
esac
