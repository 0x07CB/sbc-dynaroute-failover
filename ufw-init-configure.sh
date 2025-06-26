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

# Usage: ./ufw-init-configure.sh <interface_principale> <interface_secours>
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <interface_principale> <interface_secours>"
    echo "Example: $0 eth0 wlan0"
    exit 1
fi

# === DÉCLARATION DES INTERFACES ===
MAIN_IF="$1"
BACKUP_IF="$2"

# Vérification de l'existence des interfaces
if ! ip link show "$MAIN_IF" &>/dev/null; then
    echo "L'interface principale '$MAIN_IF' n'existe pas."
    exit 1
fi
if ! ip link show "$BACKUP_IF" &>/dev/null; then
    echo "L'interface de secours '$BACKUP_IF' n'existe pas."
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

# (Ne pas appliquer de règles de ports spécifiques ici)
# La gestion dynamique des ports/services selon l'interface active doit être faite par le script check_network_and_ufw.sh

# === RÈGLES SPÉCIFIQUES (À ADAPTER SELON VOS SERVICES) ===
if [[ -f ./ufw-custom-rules.sh ]]; then
    bash ./ufw-custom-rules.sh "$MAIN_IF" "$BACKUP_IF"
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





