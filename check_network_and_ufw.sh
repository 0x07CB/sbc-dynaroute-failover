#!/bin/bash
# nom du script: check_network_and_ufw.sh
# Description: Bascule la route par défaut et adapte dynamiquement les règles UFW selon l'interface active
# Usage: sudo ./check_network_and_ufw.sh eth0 wlan0

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <interface_principale> <interface_secours>"
    exit 1
fi

MAIN_IF="$1"
BACKUP_IF="$2"

# Définition des ports/services à gérer dynamiquement (comme dans ufw-init-configure.sh)
PORTS_UDP=(53 123 67 161)
PORTS_TCP=(80 443 22 21 25 110 143)

# Fonction pour appliquer les règles dynamiques sur une interface donnée
apply_ufw_rules() {
    local IFACE_ALLOW="$1"
    local IFACE_DENY="$2"

    # D'abord, retirer les règles existantes pour éviter les doublons
    for port in "${PORTS_UDP[@]}"; do
        ufw delete allow out on "$IFACE_DENY" to any port $port proto udp 2>/dev/null
        ufw delete allow out on "$IFACE_ALLOW" to any port $port proto udp 2>/dev/null
        ufw delete deny out on "$IFACE_DENY" to any port $port proto udp 2>/dev/null
        ufw delete deny out on "$IFACE_ALLOW" to any port $port proto udp 2>/dev/null
    done
    for port in "${PORTS_TCP[@]}"; do
        ufw delete allow out on "$IFACE_DENY" to any port $port proto tcp 2>/dev/null
        ufw delete allow out on "$IFACE_ALLOW" to any port $port proto tcp 2>/dev/null
        ufw delete deny out on "$IFACE_DENY" to any port $port proto tcp 2>/dev/null
        ufw delete deny out on "$IFACE_ALLOW" to any port $port proto tcp 2>/dev/null
    done

    # Appliquer les règles : autoriser sur l'interface active, refuser sur l'autre
    for port in "${PORTS_UDP[@]}"; do
        ufw allow out on "$IFACE_ALLOW" to any port $port proto udp
        ufw deny out on "$IFACE_DENY" to any port $port proto udp
    done
    for port in "${PORTS_TCP[@]}"; do
        ufw allow out on "$IFACE_ALLOW" to any port $port proto tcp
        ufw deny out on "$IFACE_DENY" to any port $port proto tcp
    done
}

# Teste la connectivité sur l'interface principale
if ping -I "$MAIN_IF" -c 1 8.8.8.8 &>/dev/null; then
    # Interface principale OK
    ip route replace default dev "$MAIN_IF"
    apply_ufw_rules "$MAIN_IF" "$BACKUP_IF"
    echo "Route par défaut sur $MAIN_IF, UFW strict sur $BACKUP_IF."
else
    # Basculement sur l'interface de secours
    ip route replace default dev "$BACKUP_IF"
    apply_ufw_rules "$BACKUP_IF" "$MAIN_IF"
    echo "Route par défaut sur $BACKUP_IF, UFW strict sur $MAIN_IF."
fi

# Afficher l'état UFW
ufw status verbose
