#!/usr/bin/env bash
set -euo pipefail

HYPR_DIR="$HOME/.config/hypr"
HOST="$(hostname)"

case "$HOST" in
  tentop|hp-laptop)
    MACHINE="laptop"
    ;;
  desktop|arch-desktop)
    MACHINE="desktop"
    ;;
  *)
    echo "Unknown host: $HOST"
    exit 1
    ;;
esac

ln -sf "$HYPR_DIR/machines/$MACHINE/monitors.conf" "$HYPR_DIR/monitors.conf"

echo "Linked Hyprland config for $MACHINE"
