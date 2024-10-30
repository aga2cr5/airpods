#!/usr/bin/bash

# Check if AirPods name is provided as an argument
if [ $# -ge 1 ]; then
    AIRPODS_NAME="$1"
else
    AIRPODS_NAME="AirPods Pro"
fi

# Find the AirPods MAC address using the provided name
DEVICE_INFO=$(bluetoothctl devices | grep -F "$AIRPODS_NAME")
DEVICE_MAC=$(echo "$DEVICE_INFO" | awk '{print $2}')

# Exit if the AirPods are not found
if [ -z "$DEVICE_MAC" ]; then
    exit 1
fi

# Get the connection status of the AirPods
DEVICE_STATUS=$(bluetoothctl info "$DEVICE_MAC")

if echo "$DEVICE_STATUS" | grep -q "Connected: yes"; then
    # If connected, disconnect the AirPods silently
    bluetoothctl disconnect "$DEVICE_MAC" >/dev/null 2>&1
else
    # If not connected, connect the AirPods silently
    bluetoothctl connect "$DEVICE_MAC" >/dev/null 2>&1
fi
