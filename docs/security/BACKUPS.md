# Sauvegardes — état du 18 octobre 2026

Voir le [compte rendu détaillé](../operations/sauvegardes-2026-10-18.md).

Deux étages : archives locales Pterodactyl par serveur, puis script hôte SQL/site/configurations + archives Pterodactyl vers Backblaze via Rclone chiffré.

- pteroq actif et cron Artisan chaque minute installés.
- Schedules déclarés créés : Survival 02:00, Lobby 02:20, Build 02:40, Velocity 03:00, bot 03:10, heure panel Europe/Paris.
- Envoi hôte : 03:30 UTC, `/etc/cron.d/lodge-backup`.
- Rétention par défaut : objets distants 14 jours ; dossiers quotidiens locaux `-mtime +3`, environ 4 jours. La rétention des archives Pterodactyl est distincte et reste à contrôler.
- Test manuel : 7 fichiers téléchargés/déchiffrés, SHA-256 identiques, gzip/tar lisibles ; une seule archive Survival présente.
- Première nuit automatique, couverture des cinq instances et restauration applicative : à valider.

Attention : `save-off` + délai fixe avant `save-on` n'est pas une coordination fiable avec la fin effective d'une sauvegarde. Les dumps SQL et mondes ne constituent pas un snapshot atomique commun. Le script peut réussir avec une archive ancienne : fraîcheur et couverture doivent être supervisées.

Les clés de déchiffrement doivent être conservées séparément du VPS pour permettre une reprise après perte totale. Aucun dump, `.env`, `rclone.conf`, export de comptes, archive ou clé ne doit entrer dans Git.
