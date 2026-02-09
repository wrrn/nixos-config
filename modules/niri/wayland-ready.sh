#!/bin/sh

set -eu

: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"

## Get the first wayland socket available (alphabetically)
if [ -z "${WAYLAND_DISPLAY:-}" ]; then
    for _ in $(seq 1 200); do
        for s in "$XDG_RUNTIME_DIR"/wayland-*; do
            [ -S "$s" ] && export WAYLAND_DISPLAY="${s##*/}" && break
        done


        ## Have we found the WAYLAND display yet?
        [ -n "${WAYLAND_DISPLAY:-}" ] &&
            break
        sleep 0.05
    done
fi

[ -n "${WAYLAND_DISPLAY:-}" ] && [ -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]

systemctl --user import-environment WAYLAND_DISPLAY XDG_RUNTIME_DIR
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_RUNTIME_DIR
