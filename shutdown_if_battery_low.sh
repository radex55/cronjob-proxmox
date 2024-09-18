#!/bin/bash

# File marker untuk memastikan shutdown hanya dilakukan sekali
MARKER_FILE="/tmp/shutdown_marker"
MARKER_FILE_FCM="/tmp/shutdown_marker_fcm"
MARKER_FILE_SH_NOW="/tmp/shutdown_marker_now"

# Cek kapasitas baterai
BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)

# Jika kapasitas baterai di bawah 43% dan marker file tidak ada
if [ "$BATTERY_CAPACITY" -lt 43 ] && [ ! -f "$MARKER_FILE" ]; then
    # Tandai bahwa shutdown sudah dilakukan
    touch "$MARKER_FILE"

    # Hentikan semua VM di Proxmox
    for VMID in $(/usr/sbin/qm list | awk '{if(NR>1)print $1}'); do
        echo "Stopping VM $VMID..."
        /usr/sbin/qm stop $VMID
    done
fi

# Jika kapasitas baterai di bawah 40% dan marker file tidak ada
if [ "$BATTERY_CAPACITY" -lt 40 ] && [ ! -f "$MARKER_FILE_SH_NOW" ]; then
    # Tandai bahwa shutdown sudah dilakukan
    touch "$MARKER_FILE_SH_NOW"

    # Shutdown sistem
    echo "Shutting down Proxmox..."
    /sbin/shutdown -h now
fi
