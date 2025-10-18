#!/usr/bin/env bash
set -euo pipefail

config="$HOME/.config/wofi/short_top_search_config"
style="$HOME/.config/wofi/short_top_search_style.css"

get_current_airplane_status() {
  airplane_status="$(airplane_mode | jq -r '.class' | tr -d '[:space:]')"
  if [ "$airplane_status" = "on" ]; then
    airplane_icon="󰀞"
    airplane_status="OFF"
    echo "<span foreground='green'>$airplane_icon</span>  Airplane Mode $airplane_status"
  else
    airplane_icon="󰀝"
    airplane_status="ON"
    echo "<span foreground='#8FA6FF'>$airplane_icon</span>  Airplane Mode $airplane_status"
  fi
}

check_battery_mode() {
  battery_mode_status="$(bat_mode_switcher | jq -r '.class' | tr -d '[:space:]')"
  if [ "$battery_mode_status" = "powersave" ]; then
    battery_mode_status="Performance"
    battery_mode_icon=""
    echo "<span foreground='orange'>$battery_mode_icon</span>  $battery_mode_status"
  else
    battery_mode_status="Powersave"
    battery_mode_icon="󰌪"
    echo "<span foreground='green'>$battery_mode_icon</span>  $battery_mode_status"
  fi
}

check_nordvpn_server() {
  output="$(nordvpn status)"

  status="$(awk -F': ' '/^Status:/ {print $2}' <<< "$output")"
  server="$(awk -F': ' '/^Server:/ {print $2}' <<< "$output")"
  if [ -z "$server" ]; then
    echo "<span foreground='#3E5FFF'>󰻌 </span> NordVPN"
  else
    echo "<span foreground='#3E5FFF'> </span> NordVPN $server"
  fi
}

check_sunsetr_state() {
  STATE_FILE="$HOME/.cache/sunsetr/state.flag"
  icon_on=""
  icon_off=""
  state=$(cat "$STATE_FILE")
  if [ "$state" == "on" ]; then
      echo "<span foreground='yellow'>$icon_off </span> Sunsetr Off"
  else
      echo "<span foreground='lightblue'>$icon_on </span> Sunsetr On"
  fi
}

check_dse_vpn_state() {
  if ip link show dse &>/dev/null; then
      echo "<span foreground='red'> </span> DSE VPN Off"
  else
      echo "<span foreground='#1689ca'> </span> DSE VPN On"
  fi
}

check_hypridle_state() {
  STATE_FILE="/tmp/hypridle_inhibit"
  icon_on=""
  icon_off=""
  if [[ -f "$STATE_FILE" ]]; then
      echo "<span foreground='green'>$icon_off </span> Inhibit Off"
  else
      echo "<span foreground='#FFB86C'>$icon_on </span> Inhibit On"
  fi
}

power_off_action="<span foreground='red'> </span> Shutdown"
reboot_action="<span foreground='green'> </span> Reboot"
lock_action="<span foreground='#90A4AE'> </span> Lock"
battery_action=$(check_battery_mode)
airplane_action=$(get_current_airplane_status)
fullcharge_action="<span foreground='green'>󰁹</span>  Fullcharge"
send_notification_action="<span foreground='lightblue'>󰍣 </span> Send notification"
nordvpn_action=$(check_nordvpn_server)
wifi_action="<span foreground='#FFB86C'>󰖩 </span> WiFi"
bluetooth_action="<span foreground='#FF79C6'>󰂯 </span> Bluetooth"
homeassistant_action="<span foreground='#41BDF5'>󰟐 </span> Home Assistant"
sunsetr_action=$(check_sunsetr_state)
hypridle_action=$(check_hypridle_state)
dse_vpn_action=$(check_dse_vpn_state)
monitor_action="<span foreground='#3E5FFF'>󰍹 </span> Monitor Control"



# Show menu with icon included
choice="$(printf '%s\n' \
  "$power_off_action" \
  "$reboot_action" \
  "$lock_action" \
  "$battery_action" \
  "$fullcharge_action" \
  "$send_notification_action" \
  "$nordvpn_action" \
  "$airplane_action" \
  "$wifi_action" \
  "$bluetooth_action" \
  "$homeassistant_action" \
  "$sunsetr_action" \
  "$hypridle_action" \
  "$dse_vpn_action" \
  "$monitor_action" \
  | wofi --conf $config --style $style --show=dmenu --prompt='Action Menu' --allow-markup --parse-search)"

# Handle selection
case "$choice" in
  "$power_off_action")       systemctl poweroff ;;
  "$reboot_action")          systemctl reboot ;;
  "$lock_action")            hyprlock & ;;
  "$battery_action") bat_mode_switcher toggle ;;
  "$fullcharge_action") fullcharge ;;
  "$send_notification_action") notification_menu ;;
  "$nordvpn_action") nordvpn_menu ;;
  "$airplane_action") airplane_mode toggle ;;
  "$wifi_action") networkmanager_dmenu -l wofi --width 650 ;;
  "$bluetooth_action") wofi-bluetooth ;;
  "$homeassistant_action") homeassistant_menu ;;
  "$sunsetr_action") toggle_sunsetr ;;
  "$hypridle_action") hypridle_inhibit toggle ;;
  "$dse_vpn_action") dse_vpn toggle;;
  "$monitor_action") display_quick_switch;;
  ""|*) exit 0 ;;
esac


