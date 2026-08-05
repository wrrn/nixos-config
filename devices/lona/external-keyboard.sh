#!/usr/bin/env bash

set -euo pipefail

usage() {
  printf '%s\n' \
    "Usage: external-keyboard-monitor [options]" \
    "" \
    "Options:" \
    "  --internal-keyboard-sysfs PATH  Internal keyboard's sysfs input directory" \
    "  --keychron-bluez-path PATH      Keychron's BlueZ D-Bus object path" \
    "  --sweep-usb-vendor-id ID        Sweep's four-digit USB vendor ID" \
    "  --sweep-usb-product-id ID       Sweep's four-digit USB product ID" \
    "  --help                          Show this help"
}

require_argument() {
  if (( $# < 2 )) || [[ -z "$2" ]]; then
    printf 'Missing argument for %s\n' "$1" >&2
    usage >&2
    exit 2
  fi
}

internal_keyboard_sysfs=""
keychron_bluez_path=""
sweep_usb_vendor_id=""
sweep_usb_product_id=""

while (( $# > 0 )); do
  case "$1" in
    --internal-keyboard-sysfs)
      require_argument "$@"
      internal_keyboard_sysfs="$2"
      shift 2
      ;;
    --keychron-bluez-path)
      require_argument "$@"
      keychron_bluez_path="$2"
      shift 2
      ;;
    --sweep-usb-vendor-id)
      require_argument "$@"
      sweep_usb_vendor_id="$2"
      shift 2
      ;;
    --sweep-usb-product-id)
      require_argument "$@"
      sweep_usb_product_id="$2"
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$internal_keyboard_sysfs" \
  || -z "$keychron_bluez_path" \
  || -z "$sweep_usb_vendor_id" \
  || -z "$sweep_usb_product_id" ]]; then
  printf 'All keyboard options are required.\n' >&2
  usage >&2
  exit 2
fi

set_inhibited() {
  local value="$1"

  for inhibit_path in "$internal_keyboard_sysfs"/input*/inhibited; do
    if [[ -e "$inhibit_path" ]]; then
      printf '%s\n' "$value" > "$inhibit_path" || true
    fi
  done
}

keychron_connected() {
  local connected
  connected="$(busctl --system --timeout=1s get-property \
    org.bluez \
    "$keychron_bluez_path" \
    org.bluez.Device1 \
    Connected 2>/dev/null || true)"
  [[ "$connected" == "b true" ]]
}

sweep_connected() {
  local device_path
  local vendor_path

  for vendor_path in /sys/bus/usb/devices/*/idVendor; do
    [[ -e "$vendor_path" ]] || continue
    device_path="${vendor_path%/idVendor}"

    if [[ "$(<"$vendor_path")" == "$sweep_usb_vendor_id" ]] \
      && [[ -r "$device_path/idProduct" ]] \
      && [[ "$(<"$device_path/idProduct")" == "$sweep_usb_product_id" ]]; then
      return 0
    fi
  done

  return 1
}

cleanup() {
  set_inhibited 0
}

trap cleanup EXIT
trap 'exit 0' INT TERM

last_state=""
while true; do
  state=0
  if keychron_connected || sweep_connected; then
    state=1
  fi

  if [[ "$state" != "$last_state" ]]; then
    set_inhibited "$state"
    last_state="$state"
  fi

  sleep 1
done
