#!/bin/bash
# nom du script: check_network.sh
# Description: Vérifie la connectivité réseau et bascule entre les interfaces principales et de secours
# Usage: ./check_network.sh <interface_principale> <interface_secours>

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <interface_principale> <interface_secours>"
    exit 1
fi

# Définition des interfaces
MAIN_IF="$1"
BACKUP_IF="$2"

# Teste la connectivité sur l'interface principale
if ping -I "$MAIN_IF" -c 1 8.8.8.8 &>/dev/null; then
    ip route replace default dev "$MAIN_IF"
else
    ip route replace default dev "$BACKUP_IF"
fi