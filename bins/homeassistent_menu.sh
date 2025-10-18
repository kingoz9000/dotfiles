HA_URL="http://192.168.1.88:8123"
export HA_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI1NDAwOTA1NWRkNzI0NjRlOWMwOThkY2IzMGU2OTNjYyIsImlhdCI6MTc1NjU2NDAwMywiZXhwIjoyMDcxOTI0MDAzfQ.Q1NgcH2LM2lhmEKwCiOuwyyJjJMJRNvcFtWIIItoBmo

config="$HOME/.config/wofi/short_top_search_config"
style="$HOME/.config/wofi/short_top_search_style.css"


toggle_light() {
  local light="$1"
  curl -s -X POST -H "Authorization: Bearer $HA_TOKEN" \
       -H "Content-Type: application/json" \
       -d "{\"entity_id\": \"$light\"}" \
       $HA_URL/api/services/light/toggle
}

is_running() {
  state=$(curl -s -H "Authorization: Bearer $HA_TOKEN" $HA_URL/api/ | jq -r '.message')

  if [[ "${state,,}" == "api running." ]]; then
    return 0
  else
    notify-send "Home Assistant is not running"
    return 1
  fi
}

make_pretty_state_string() {
  local lights="$1"
  local pretty=""
  local entity name state icon color

  # Read each "entity:name:state" line without spawning a subshell
  while IFS=: read -r entity name state; do
    case "$state" in
      on)  icon="󰛨"; color="yellow" ;;
      off) icon="󰛩"; color="gray"   ;;  # "gray" works well with Pango color names
      *)   icon="󱧤"; color="white"  ;;
    esac

    # Append a line WITH a newline preserved
    printf -v pretty "%s<span foreground='%s'>%s</span>  %s\n" \
      "$pretty" "$color" "$icon" "$name"
  done <<< "$lights"

  printf "%s" "$pretty"
}

show_menu() {
  local lights="$1"
  echo "$lights" | awk -F: '{printf "%-30s %s\n", $1, $2}' | wofi --dmenu --conf $config --style $style --prompt "Home Assistant Lights"
}

if ! is_running; then
  exit 1
fi

lights=$(curl -s -H "Authorization: Bearer $HA_TOKEN" $HA_URL/api/states |
  jq -r '.[] | select(.entity_id | startswith("light.")) | "\(.entity_id):\(.attributes.friendly_name):\(.state)"')

pretty_lights=$(make_pretty_state_string "$lights")

# 1) Show menu (make sure show_menu uses --allow-markup)
choice=$(show_menu "$pretty_lights")
if [[ -z "$choice" ]]; then
  exit 0
fi

choice_name=$(echo "$choice" \
  | sed -E 's/.*<\/span>[[:space:]]*//' \
  | sed -E 's/^[[:space:]]+|[[:space:]]+$//g' \
  | tr -d '\r' \
  | sed $'s/\xC2\xA0/ /g')   # replace non-breaking spaces if any

# 2) find entity_id by friendly name (also trim field in the data)
entity_id=$(awk -F: -v n="$choice_name" '{
  gsub(/^[ \t]+|[ \t]+$/, "", $2);   # trim name field
  if ($2==n) { print $1; exit }
}' <<< "$lights")

toggle_light "$entity_id"
notify-send "Toggled $choice_name"

curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states" \
| jq -r '.[] | select(.entity_id | startswith("scene.")) 
         | "\(.entity_id):\(.attributes.friendly_name):\(.state)"'
