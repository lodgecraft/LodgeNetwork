# Services — 18 octobre 2026

| Composant | Fonction / état documenté |
| --- | --- |
| Docker / Wings | Exécution des instances Pterodactyl |
| Panel Pterodactyl | Administration web, répertoire `/var/www/pterodactyl` |
| pteroq.service | Worker Artisan, www-data ; installé, actif et activé au démarrage |
| cron | Scheduler panel chaque minute et sauvegarde hôte quotidienne |
| MariaDB | Bases `lodge_core`, `lodgecraft_web`, `panel` |
| Redis | Service actif lors du diagnostic du 18 octobre |
| Nginx / PHP-FPM 8.3 | Azuriom, panel et services web selon virtual hosts |
| Azuriom | Site `/var/www/azuriom/public`, wiki et packs ; 1.2.13 lors de la bascule |
| Rclone | Envoi des sauvegardes vers `lodgecrypt:daily/`, Backblaze avec chiffrement côté client |
| Fail2Ban | Protection SSH/Nginx documentée ; jails à contrôler lors d'un audit actif |

## SQL

Comptes dédiés créés : `lodge_proxy` pour LodgeMotd, `lodge_votes` pour LodgeVotesProxy, `lodge_discord` pour le bot. Droits table par table et maximum de 10 connexions par compte selon le bilan fourni. Les plugins Paper conservent `lodge_core`. Aucun identifiant secret dans Git.

## Notifications

Le démarrage du worker a traité d'anciennes notifications `ServerInstalled` en échec ; cause non diagnostiquée. Les backups ont néanmoins réussi. Le succès d'un job schedule ne prouve pas à lui seul la réussite finale d'une archive.
