# LodgeNetwork

Documentation et modèles de l'infrastructure LodgeCraft. État révisé le 18 octobre 2026, avant la bêta publique du 1er novembre.

## État actuel

VPS OVH Ubuntu 24.04.5, Docker/Pterodactyl/Wings, Velocity et trois Paper 1.21.8 (Lobby, Survival, Build), bot Discord, Nginx/Azuriom, MariaDB et Redis.

- [Architecture réseau](docs/architecture/NETWORK.md)
- [Ports](docs/architecture/PORTS.md)
- [Services](docs/architecture/SERVICES.md)
- [Ressources et standards](docs/architecture/SERVER_STANDARDS.md)
- [Déploiement](docs/architecture/DEPLOYMENT.md)
- [Pare-feu](docs/security/FIREWALL.md)
- [Sauvegardes](docs/security/BACKUPS.md)
- [Compte rendu des sauvegardes](docs/operations/sauvegardes-2026-10-18.md)
- [Build à la demande — spécification, non déployée](docs/architecture/BUILD_ON_DEMAND.md)

Les paramètres confirmés par l'exploitant sont distingués des valeurs historiques à vérifier. Cette documentation n'est pas un inventaire automatique du VPS. Aucun secret, dump ou archive de production ne doit être ajouté à Git.
