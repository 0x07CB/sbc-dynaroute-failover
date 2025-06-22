#!/bin/bash
#
# author: Richard Daniel Sanchez
#
# ########################

function check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "This script must be run as root or with sudo."
        exit 1
    fi
}

check_root

# Usage: ./ufw-init-configure.sh <wireless_interface> <ethernet_interface>
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <wireless_interface> <ethernet_interface>"
    echo "Example: $0 wlan0 eth0"
    exit 1
fi

# === DÉCLARATION DE L'INTERFACE CIBLE ===
WIRELESS_INTERFACE="$1"
ETHERNET_INTERFACE="$2"

# Vérification de l'existence des interfaces
if ! ip link show "$WIRELESS_INTERFACE" &>/dev/null; then
    echo "Wireless interface '$WIRELESS_INTERFACE' does not exist."
    exit 1
fi
if ! ip link show "$ETHERNET_INTERFACE" &>/dev/null; then
    echo "Ethernet interface '$ETHERNET_INTERFACE' does not exist."
    exit 1
fi

# === STOP & RESET UFW ===
systemctl disable --now ufw
ufw disable
ufw reset

# === POLITIQUES PAR DÉFAUT ===
ufw default deny incoming
ufw default deny outgoing

# === ACTIVER LES LOGS EN MODE VERBEUX ===
ufw logging high

# === RÈGLES SORTANTES POUR APT UNIQUEMENT ===

# Bloquer les ports courants en sortie sur le Wi-Fi
ufw deny out on "$WIRELESS_INTERFACE" to any port 53 proto udp
ufw deny out on "$WIRELESS_INTERFACE" to any port 80 proto tcp
ufw deny out on "$WIRELESS_INTERFACE" to any port 443 proto tcp
ufw deny out on "$WIRELESS_INTERFACE" to any port 22 proto tcp
ufw deny out on "$WIRELESS_INTERFACE" to any port 21 proto tcp
ufw deny out on "$WIRELESS_INTERFACE" to any port 25 proto tcp
ufw deny out on "$WIRELESS_INTERFACE" to any port 110 proto tcp
ufw deny out on "$WIRELESS_INTERFACE" to any port 143 proto tcp
ufw deny out on "$WIRELESS_INTERFACE" to any port 123 proto udp
ufw deny out on "$WIRELESS_INTERFACE" to any port 67 proto udp
ufw deny out on "$WIRELESS_INTERFACE" to any port 161 proto udp

# Autoriser les mêmes ports en sortie sur l'Ethernet
ufw allow out on "$ETHERNET_INTERFACE" to any port 53 proto udp
ufw allow out on "$ETHERNET_INTERFACE" to any port 80 proto tcp
ufw allow out on "$ETHERNET_INTERFACE" to any port 443 proto tcp
ufw allow out on "$ETHERNET_INTERFACE" to any port 22 proto tcp
ufw allow out on "$ETHERNET_INTERFACE" to any port 21 proto tcp
ufw allow out on "$ETHERNET_INTERFACE" to any port 25 proto tcp
ufw allow out on "$ETHERNET_INTERFACE" to any port 110 proto tcp
ufw allow out on "$ETHERNET_INTERFACE" to any port 143 proto tcp
ufw allow out on "$ETHERNET_INTERFACE" to any port 123 proto udp
ufw allow out on "$ETHERNET_INTERFACE" to any port 67 proto udp
ufw allow out on "$ETHERNET_INTERFACE" to any port 161 proto udp

# === (OPTIONNEL) AUTORISER RETOUR DES PAQUETS DES CONNEXIONS ÉTABLIES ===
# UFW gère déjà ça automatiquement

# === (OPTIONNEL) BLOQUER TOUT LE RESTE SUR CETTE INTERFACE ===
# ufw deny in on "$WIRELESS_INTERFACE"
# ufw deny out on "$WIRELESS_INTERFACE"

# === RÈGLES SPÉCIFIQUES (À ADAPTER SELON VOS SERVICES) ===
# Si un fichier ufw-custom-rules.sh existe, il sera exécuté ici pour appliquer des règles personnalisées.
if [[ -f ./ufw-custom-rules.sh ]]; then
    bash ./ufw-custom-rules.sh "$WIRELESS_INTERFACE" "$ETHERNET_INTERFACE"
fi

# === ACTIVER UFW ===
ufw enable
systemctl enable --now ufw

# === RECHARGER UFW ===
ufw reload

# === VÉRIFICATION DES RÈGLES ===
echo "Vérification des règles UFW..."
ufw status verbose
systemctl status ufw

# === VÉRIFICATION DES LOGS ===
# Les logs sont généralement dans /var/log/ufw.log
# Pour consulter : less /var/log/ufw.log





