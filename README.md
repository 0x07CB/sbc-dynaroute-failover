# sbc-dynaroute-failover
> Scripts bash pour la gestion dynamique du firewall UFW et du routage réseau sur SBC à double interface, avec bascule automatique et sécurité renforcée.

Scripts bash pour la gestion dynamique du pare-feu UFW et du routage réseau sur single board computers (SBC) avec deux interfaces réseau (Ethernet/Wi-Fi). Idéal pour les home-labs, petits serveurs ou appliances DIY nécessitant sécurité et bascule automatique en cas de coupure d’interface.

## Fonctionnalités principales
- Bascule automatique de la route par défaut selon la connectivité réseau.
- Application dynamique de règles UFW selon l’interface active (Ethernet ou Wi-Fi).
- Sécurité renforcée : politiques par défaut restrictives, logs UFW, gestion fine des ports/services.
- Scripts modulaires et personnalisables.

## Structure des scripts
- `install-packages.sh` : Installe les dépendances nécessaires (`ufw`, `ifmetric`).
- `ufw-init-configure.sh` : Initialise UFW, applique les règles de base et exécute les règles personnalisées.
- `ufw-custom-rules.sh` : Ajoutez ici vos règles UFW spécifiques (exemples fournis).
- `set_ifmetrics.sh` : Définit la priorité de routage des interfaces (metric).
- `check_network.sh` : Bascule la route par défaut selon la connectivité.
- `check_network_and_ufw.sh` : Bascule la route ET adapte dynamiquement les règles UFW.

## Installation
```bash
sudo ./install-packages.sh
```

## Utilisation
### 1. Initialiser UFW et appliquer les règles de base
```bash
sudo ./ufw-init-configure.sh wlan0 eth0
```

### 2. Définir la priorité de routage
```bash
sudo ./set_ifmetrics.sh eth0 wlan0
```

### 3. Bascule automatique de la route et des règles UFW
```bash
sudo ./check_network_and_ufw.sh eth0 wlan0
```

> Adapter les noms d’interfaces selon votre matériel (`ip link` pour les lister).

## Personnalisation des règles UFW
Modifiez le fichier `ufw-custom-rules.sh` pour ajouter vos propres règles (exemples commentés dans le fichier).

## Exemples de cas d’usage
- Serveur domestique avec double connectivité (Ethernet/Wi-Fi).
- Appliance réseau DIY nécessitant une sécurité renforcée et une tolérance de panne.

## Dépendances
- `ufw`
- `ifmetric`

## Auteur
- Richard Daniel Sanchez

## Licence
MIT

