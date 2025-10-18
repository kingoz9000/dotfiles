#!/usr/bin/env bash
config="$HOME/.config/wofi/short_top_search_config"
style="$HOME/.config/wofi/short_top_search_style.css"

handle_servers() {
  server_choice="$(nordvpn countries | tr -s ' ' '\n' | wofi --show=dmenu --prompt='Select Server')"
  if [ -n "$server_choice" ]; then
    server_name=$(echo "$server_choice" | awk -F ' - ' '{print $1}')
    nordvpn connect "$server_name"
  fi
}

output="$(nordvpn status)"

status="$(awk -F': ' '/^Status:/ {print $2}' <<< "$output")"
server="$(awk -F': ' '/^Server:/ {print $2}' <<< "$output")"

if [ "$status" = "Connected" ]; then
  choice="$(printf '%s\n' \
    "Disconnect" \
    "Servers" \
    "Settings" \
    | wofi --conf $config --show=dmenu --prompt='NordVPN Menu')"
else
  choice="$(printf '%s\n' \
    "Quick Connect" \
    "Servers" \
    "Settings" \
    | wofi --conf $config --style $style --show=dmenu --prompt='NordVPN Menu')"
fi


# Handle selection
case "$choice" in
  "Quick Connect")      nordvpn connect ;;
  "Disconnect")         nordvpn disconnect ;;
  "Servers")            handle_servers ;;
  "Settings")           handle_settings ;;
  ""|*) exit 0 ;;
esac

