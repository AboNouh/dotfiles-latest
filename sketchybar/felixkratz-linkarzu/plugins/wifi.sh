#!/bin/bash

# Filename: ~/github/dotfiles-latest/sketchybar/felixkratz-linkarzu/plugins/wifi.sh

update() {
  source "$CONFIG_DIR/icons.sh"
  SSID="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: ' '/ SSID: / {print $2}')"
  INTERFACE="$(route get default | grep interface | awk '{print $2}')"

  # Adjust IP assignment based on the active interface
  if [ "$INTERFACE" = "en0" ]; then
    IP="$(ipconfig getifaddr en0)"
    ICON="$ETHERNET_CONNECTED"
  else
    IP="$(ipconfig getifaddr en1)" # Assuming en1 is WiFi
    ICON="$([ -n "$IP" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"
  fi

  LABEL="$([ -n "$IP" ] && echo "$SSID ($IP)" || echo "Disconnected")"

  sketchybar --set $NAME icon="$ICON" label="$LABEL"
}

click() {
  CURRENT_WIDTH="$(sketchybar --query $NAME | jq -r .label.width)"

  WIDTH=0
  if [ "$CURRENT_WIDTH" -eq "0" ]; then
    WIDTH=dynamic
  fi

  sketchybar --animate sin 20 --set $NAME label.width="$WIDTH"
}

case "$SENDER" in
"wifi_change")
  update
  ;;
"mouse.clicked")
  click
  ;;
esac
