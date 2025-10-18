check_clipboard_image() {
  if wl-paste --list-types | grep -q '^image/'; then
    return 0  # Image found
  else
    return 1  # No image
  fi
}


notification_menu() {

  device_picker_config="$HOME/.config/wofi/device_picker_config"
  device_picker_cmd="wofi --conf $device_picker_config --show dmenu --prompt 'Device for notification'"
  notification_sender_config="$HOME/.config/wofi/notification_sender_config"
  notification_sender_style="$HOME/.config/wofi/notification_sender_style.css"
  tmp_img_path="/tmp/clipboard_image.png"

  title_prompt="Title for notification, q for exit"
  message_prompt="Message for notification, + for clipboard, q for exit"

  is_url=false

  device=$(printf "Iphone\nBoox" | $device_picker_cmd)
  [ -z "$device" ] && exit 0

  title=$(echo "" | wofi --conf $notification_sender_config --style $notification_sender_style --show dmenu --prompt "$title_prompt")
  [ -z "$title" ] && title="Notification"

  if [ "$title" = "q" ]; then
    notify-send "Notification cancelled" 
    exit 0
  fi

  message=$(echo "" | wofi --conf $notification_sender_config --style $notification_sender_style --show dmenu --prompt "$message_prompt")
  [ -z "$message" ] && message=""

if [[ "$message" =~ ^https?:// ]]; then
  is_url=true
fi

  case "$message" in
    "q")
      notify-send "Notification cancelled"
      exit 0
      ;;

    "+")
      if check_clipboard_image; then
        wl-paste > "$tmp_img_path"
        output=$(send_notification -d "$device" -t "$title" -i /tmp/clipboard_image.png)
        rm /tmp/clipboard_image.png
        notify-send --app-name=long-msg "Image sent to $device" "$output"
        exit 0
      else
        message=$(wl-paste)
        output=$(send_notification -d "$device" -t "$title" -m "$message")
        notify-send --app-name=long-msg "Notification sent to $device" "$output"
        exit 0
      fi
      ;;
    "")
      notify-send "Notification cancelled"
      exit 0
      ;;

    *)
      if [ "$is_url" = true ]; then
        output=$(send_notification -d "$device" -t "$title" -u "$message")
        notify-send --app-name=long-msg "URL sent to $device" "$output"
        exit 0
      else
        output=$(send_notification -d "$device" -t "$title" -m "$message")
        notify-send --app-name=long-msg "Notification sent to $device" "$output"
        exit 0
      fi

      ;;
  esac

}

notification_menu
