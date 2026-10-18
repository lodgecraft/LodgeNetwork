# Ports — 18 octobre 2026

| Service | Port | Accès attendu |
| --- | ---: | --- |
| SSH | 22 | Administration de l'hôte |
| Nginx | 80 / 443 | Web |
| Wings API TLS | 8080 | Administration, configuration actuelle à relever |
| Wings SFTP | 2022 | Administration, configuration actuelle à relever |
| Velocity | 25565 | Entrée publique Minecraft |
| Lobby | 25566 | Backend interne |
| Survival | 25567 | Backend interne |
| Bot Discord | 25568 | Allocation Pterodactyl, pas un service Minecraft public |
| Build | 25569 | Backend interne |
| VotifierPlus proxy | 8192 | Réception publique des votes |
| VotifierPlus Survival | 33447 | Récepteur précédemment configuré, accès interne |
| MariaDB | 3306 | Accès local / réseau Docker autorisé |
| Redis | 6379 | Accès local ; configuration à vérifier |

25568 n'est plus attribué à Build. Aucun port Dev/Event/Minage n'est confirmé déployé. Un port alloué n'implique pas son exposition publique.
