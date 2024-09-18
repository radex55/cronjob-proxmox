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
    rm "$MARKER_FILE"
    rm "$MARKER_FILE_SD"
    rm "$MARKER_FILE_FCM"
    rm "$MARKER_FILE_SH_NOW"

    # Buat file marker smart switch
    touch "$MARKER_FILE_SWITCH"
fi
