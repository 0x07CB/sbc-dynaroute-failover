#!/bin/bash
# nom du script: set_ifmetrics.sh
# Description: Définit les metrics des interfaces réseau pour la priorité de routage
# Usage: sudo ./set_ifmetrics.sh eth0 wlan0

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <interface_principale> <interface_secours>"
    exit 1
fi

MAIN_IF="$1"
BACKUP_IF="$2"

# Metric basse = priorité haute
ifmetric "$MAIN_IF" 100
ifmetric "$BACKUP_IF" 200

echo "Metric $MAIN_IF = 100 (prioritaire)"
echo "Metric $BACKUP_IF = 200 (secours)"
