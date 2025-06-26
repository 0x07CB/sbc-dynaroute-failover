#!/bin/bash
# ufw-custom-rules.sh
# Règles UFW spécifiques à adapter selon vos besoins/services locaux
# Usage : bash ./ufw-custom-rules.sh <interface_principale> <interface_secours>

MAIN_IF="$1"
BACKUP_IF="$2"

# === EXEMPLES DE RÈGLES SPÉCIFIQUES ===
# Décommentez/modifiez selon vos besoins !

# Port 8888
# ufw allow in on lo to any port 8888 proto tcp
# ufw allow in on "$MAIN_IF" to any port 8888 proto tcp
# ufw reject in on "$BACKUP_IF" to any port 8888 proto tcp

# Port 12922
# ufw limit in on lo to any port 12922 proto tcp
# ufw limit in on "$MAIN_IF" to any port 12922 proto tcp
# ufw reject in on "$BACKUP_IF" to any port 12922 proto tcp

# Port 2222 (ssh-tarpit)
# ufw allow in on lo to any port 2222 proto tcp

# Port 8080 (accès restreint par IP)
# MAIN_IP="192.168.3.0/24"
# BACKUP_PUBLIC_IP="192.168.1.0/24"
# BACKUP_PRIVATE_IP="172.23.1.0/16"
# ufw allow in on "$MAIN_IF" from "$MAIN_IP" to any port 8080 proto tcp
# ufw reject in on "$BACKUP_IF" from "$BACKUP_PUBLIC_IP" to any port 8080 proto tcp
# ufw allow in on "$BACKUP_IF" from "$BACKUP_PRIVATE_IP" to any port 8080 proto tcp

# Port SSH serveur personnalisé
# SSHD_SERVER_PORT=4922
# ufw reject in on "$BACKUP_IF" to any port "$SSHD_SERVER_PORT" proto tcp
# ufw limit in on "$MAIN_IF" to any port "$SSHD_SERVER_PORT" proto tcp
# ufw limit in on lo to any port "$SSHD_SERVER_PORT" proto tcp

# Ajoutez ici vos propres règles personnalisées...
