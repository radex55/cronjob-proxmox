#!/bin/bash

# Periksa kondisi apakah harus tetap eksekusi
CHARGER_STATUS=$(cat /sys/class/power_supply/BAT1/status)

# File marker untuk memastikan cron hanya dibuat sekali
MARKER_FILE="/tmp/cron_marker"
MARKER_FILE_SD="/tmp/shutdown_marker"
MARKER_FILE_FCM="/tmp/shutdown_marker_fcm"
MARKER_FILE_SH_NOW="/tmp/shutdown_marker_now"
MARKER_FILE_SWITCH="/tmp/cron_marker_switch"

# charger terhubung ("Charging || Full")
if [ "$CHARGER_STATUS" == "Charging" ] || [ "$CHARGER_STATUS" == "Full" ]; then
    # Hapus cron job
    crontab -l | grep -v "/home/shutdown_if_battery_low.sh" | crontab -
    crontab -l | grep -v "/home/cron_script.sh" | crontab -

    # Hapus marker file
    if [ -f "$MARKER_FILE" ]; then
        rm "$MARKER_FILE"
    fi
    if [ -f "$MARKER_FILE_SD" ]; then
        rm "$MARKER_FILE_SD"
    fi
    if [ -f "$MARKER_FILE_FCM" ]; then
        rm "$MARKER_FILE_FCM"
    fi
    if [ -f "$MARKER_FILE_SH_NOW" ]; then
        rm "$MARKER_FILE_SH_NOW"
    fi

    # Buat file marker smart switch
    if [ ! -f "$MARKER_FILE_SWITCH" ]; then
        touch "$MARKER_FILE_SWITCH"
    fi
fi
