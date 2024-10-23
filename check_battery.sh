#!/bin/bash

# Cek status charger ("Discharging || FULL")
CHARGER_STATUS=$(cat /sys/class/power_supply/BAT1/status)

# Cek kapasitas baterai
BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)

# File marker untuk memastikan cron hanya dibuat sekali
MARKER_FILE="/tmp/cron_marker"

# File marker smart switch untuk memastikan cron hanya dibuat sekali
MARKER_FILE_SWITCH="/tmp/cron_marker_switch"

# charger terhubung ("Full")
if [ "$CHARGER_STATUS" == "Full" ]; then
          
    # Hapus marker smart switch file
    if [ -f "$MARKER_FILE_SWITCH" ]; then
        rm "$MARKER_FILE_SWITCH"
    fi

    # Jalankan perintah bash
    /home/switch_off.sh
fi

# Jika kapasitas baterai di atas 92% maka turn off smart switch
if [ "$BATTERY_CAPACITY" -gt 92 ] && [ "$CHARGER_STATUS" == "Charging" ]; then

    # Hapus marker smart switch file
    if [ -f "$MARKER_FILE_SWITCH" ]; then
        rm "$MARKER_FILE_SWITCH"
    fi

    # Jalankan perintah bash
    /home/switch_off.sh
fi

# Jika kapasitas baterai di atas 85% maka turn off smart switch
if [ "$BATTERY_CAPACITY" -gt 85 ] && [ -f "$MARKER_FILE_SWITCH" ]; then

    # Hapus marker smart switch file
    rm "$MARKER_FILE_SWITCH"

    # Jalankan perintah bash
    /home/switch_off.sh
fi

# Jika kapasitas baterai di bawah 61% turn on smart switch
if [ "$BATTERY_CAPACITY" -lt 61 ] && [ ! -f "$MARKER_FILE_SWITCH" ]; then

    # Buat file marker smart switch
    touch "$MARKER_FILE_SWITCH"

    # Jalankan perintah
    /home/switch_on.sh
fi

# Jika charger tidak terhubung dan kapasitas baterai di bawah 55% dan marker belum dibuat
if [ "$CHARGER_STATUS" == "Discharging" ] && [ "$BATTERY_CAPACITY" -lt 55 ] && [ ! -f "$MARKER_FILE" ]; then

    # Buat file marker
    touch "$MARKER_FILE"

    # Tambahkan cron job
    (crontab -l 2>/dev/null; echo "* * * * * /home/cron_script.sh") | crontab -
    (crontab -l 2>/dev/null; echo "* * * * * /home/shutdown_if_battery_low.sh") | crontab -
fi
