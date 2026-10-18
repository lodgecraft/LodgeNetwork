# LodgeCraft — Mise en place et validation des sauvegardes

Compte rendu du 18 octobre 2026, destiné à Claude et à la documentation du dépôt d'infrastructure. Les commandes ont été exécutées par Arnold sur le VPS ; les résultats ci-dessous proviennent de ses sorties terminal. Aucun secret n'est inclus.

## Résultat

Le worker et le scheduler Pterodactyl ont été installés. Le script quotidien existant a été complété pour inclure les archives Minecraft locales dans l'envoi Backblaze chiffré. Un test manuel complet a réussi : 7 fichiers récupérés depuis Backblaze, SHA-256 identiques aux originaux, archives gzip/tar lisibles, zéro erreur.

La première nuit automatique reste à observer. Le test manuel ne contenait qu'une archive Survival. Une restauration fonctionnelle en base et un démarrage Minecraft isolé n'ont pas été effectués.

## Contexte existant

- VPS OVH Ubuntu 24.04, Docker/Pterodactyl/Wings.
- Velocity 25565 ; Lobby 25566 ; Survival 25567 ; Build 25569 ; bot Discord avec allocation 25568.
- Bases concernées : `lodge_core`, `lodgecraft_web`, `panel`.
- Rclone installé : `/usr/bin/rclone`.
- Configuration Rclone root : `/root/.config/rclone/rclone.conf` — ne jamais versionner ce fichier.
- Destination logique utilisée : `lodgecrypt:daily/`, remote chiffré devant Backblaze.
- Scripts existants : `/usr/local/sbin/lodge-backup.sh` et `/usr/local/sbin/lodge-backup-daily.sh`. Le cron appelle le second.
- Cron existant : `/etc/cron.d/lodge-backup`.

## 1. Problème initial et correction Pterodactyl

Le schedule restait en `Processing`, aucun backup n'apparaissait. `pteroq.service` était absent ; aucun worker Artisan ni déclencheur `artisan schedule:run` n'avait été détecté. Redis et cron étaient actifs, PHP CLI disponible en 8.3.35.

Création de `/etc/systemd/system/pteroq.service` :

```ini
[Unit]
Description=Pterodactyl Queue Worker
After=network.target redis-server.service
StartLimitIntervalSec=180
StartLimitBurst=30

[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/pterodactyl
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Puis `systemctl daemon-reload` et `systemctl enable --now pteroq` : service confirmé actif et activé au démarrage.

Création de `/etc/cron.d/pterodactyl`, permissions 644 :

```cron
* * * * * www-data /usr/bin/php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1
```

Le worker a repris la file en attente. Plusieurs notifications `ServerInstalled` ont échoué ; leur cause n'a pas été diagnostiquée. Les jobs `Schedule\RunTaskJob` ont ensuite été exécutés. Aucun effacement global de file n'a été fait.

Wings a confirmé la création du backup Survival `661d00ad-99f7-4980-8497-85aad7750337`, de 10:45:02 à 10:45:04 UTC, puis sa notification au panel. Adapter `wings` : stockage local dans `/var/lib/pterodactyl/backups/`, pas envoi S3 direct par Pterodactyl. Aucune ligne `APP_BACKUP_DRIVER` n'a été trouvée dans le `.env` du panel.

## 2. Schedules déclarés configurés

L'utilisateur a confirmé avoir configuré les cinq schedules après les instructions suivantes. Le relevé final détaillé de chaque schedule n'a pas été fourni.

| Serveur | Heure panel Europe/Paris | Minute / heure cron |
| --- | --- | --- |
| Survival | 02:00 | 0 / 2 |
| Lobby | 02:20 | 20 / 2 |
| Build | 02:40 | 40 / 2 |
| Velocity | 03:00 | 0 / 3 |
| Bot Discord | 03:10 | 10 / 3 |

Les trois autres champs sont `*`. Le panel a `APP_TIMEZONE=Europe/Paris`. L'OS affiche UTC. Les horaires exacts de déclenchement devront être confirmés par les logs de la première nuit ; les horaires autour du changement d'heure méritent un contrôle distinct.

Séquence demandée sur les trois Paper :

1. `save-off`, immédiatement.
2. `save-all flush`, 10 secondes après.
3. Create Backup, 10 secondes après, avec Continue on Failure.
4. `save-on`, 180 secondes après la tâche précédente.

Velocity et bot : Create Backup uniquement, sans commandes Minecraft `save-*`.

**Limite importante :** le délai fixe de 180 secondes n'est pas un mécanisme d'attente fiable de la fin d'une archive. Le premier backup a pris environ 2 secondes, mais la durée future est inconnue. Il reste à valider la cohérence des copies et à fiabiliser la réactivation de l'autosave en cas d'échec du worker ou d'une tâche précédente. `save-off` ne gèle pas nécessairement toutes les écritures des plugins ou tous les fichiers joueurs.

## 3. Sauvegarde quotidienne existante et extension

Cron existant, conservé :

```cron
30 3 * * * root /usr/local/sbin/lodge-backup-daily.sh >> /var/log/lodge-backup.log 2>&1
```

Horaire OS : 03:30 UTC chaque jour, soit 05:30 à Paris le 19 octobre, puis 04:30 en hiver. Le lancement manuel n'a pas créé `/var/log/lodge-backup.log`, car ses messages allaient dans le terminal. La redirection cron créera le fichier lors de son exécution si les permissions et le lancement sont corrects.

Le script existant effectuait déjà : dumps des trois bases, export des comptes MySQL, archives de configurations et d'Azuriom, verrou `flock`, transfert Rclone, vérification des tailles, rotation.

Les archives existantes inspectées ne contenaient pas les mondes/archives Pterodactyl. Un bloc a donc été inséré juste avant le `rclone copy` pour :

- créer `$DIR/minecraft` ;
- parcourir `/var/lib/pterodactyl/backups/*.tar.gz` ;
- copier toutes les archives locales avec `cp -p --reflink=auto` ;
- comparer taille, date et inode de la source avant/après copie ;
- valider chaque copie par `gzip -t` ;
- arrêter le script en cas d'archive modifiée, invalide ou d'absence totale d'archives ;
- compter les archives ajoutées.

Le script copie toutes les versions locales présentes, pas uniquement la dernière par serveur. Il ne vérifie ni la présence des cinq serveurs, ni la fraîcheur de chaque archive, ni le statut final dans le panel. Une seule archive suffit à passer ce contrôle. La rétention des backups Pterodactyl doit donc être définie séparément pour maîtriser le stockage local et les duplications quotidiennes.

Le patch `/tmp/patch_lodge_backup.py` a été exécuté en simulation, puis avec `--apply`. Sauvegarde créée :

`/usr/local/sbin/lodge-backup-daily.sh.bak-20261018-105940-418365`

### Correction des dates

`cp -p` conservait la date des anciennes archives. Or `rclone delete --min-age` utilise l'âge des fichiers : une archive ancienne recopiée dans un nouveau dossier quotidien risquait une suppression prématurée.

Un second patch ajoute `touch "$lodge_dest" || exit 1` sur la copie quotidienne, après validation gzip. Il ne modifie pas l'original Pterodactyl.

Patch `/tmp/fix_backup_dates.py`, simulation puis `--apply`. Sauvegarde créée :

`/usr/local/sbin/lodge-backup-daily.sh.bak-dates-20261018-111436`

Ces sauvegardes peuvent contenir des valeurs sensibles du script d'origine : ne pas les publier.

## 4. Transfert, vérification et rétention

Commandes retrouvées :

```bash
rclone copy "$DIR" "${REMOTE}daily/$DATE" --transfers 2 --retries 3
rclone check "$DIR" "${REMOTE}daily/$DATE" --size-only --one-way
rclone delete "${REMOTE}daily" --min-age "${KEEP_REMOTE_DAYS}d" --rmdirs
find "$LOCAL_ROOT" -mindepth 1 -maxdepth 1 -type d -mtime +"$KEEP_LOCAL_DAYS" -exec rm -rf {} +
```

Valeurs par défaut retrouvées : `KEEP_REMOTE_DAYS=14`, `KEEP_LOCAL_DAYS=3`.

La rotation distante porte sur l'âge des objets, pas sur le nombre de points de restauration. `find -mtime +3` correspond à des journées entières arrondies, donc environ 4 jours minimum. Ces variables peuvent être surchargées : ne pas considérer les défauts comme une preuve de toute configuration externe.

La copie quotidienne SQL et les mondes sauvegardés plus tôt ne forment pas un instantané atomique commun. Il faut en tenir compte pour restaurer une économie cohérente avec inventaires et mondes.

## 5. Test manuel réussi

Commande exécutée : `sudo /usr/local/sbin/lodge-backup-daily.sh`.

Run : `2026-10-18_1116`. Début 11:16:25 UTC, fin 11:16:54 UTC.

Opérations rapportées : dumps `lodge_core`, `lodgecraft_web`, `panel`, export des comptes, archive des configurations, archive Azuriom, ajout d'une archive Pterodactyl, envoi, vérification, rotation, message final OK.

Rclone : `0 differences found`, `7 matching files`. Le message `No common hash found` signifie qu'aucune comparaison d'empreinte commune n'a été effectuée lors de ce contrôle. Le script vérifie les tailles. Le message `Envoi vers Backblaze (15M)` précède l'ajout Minecraft : cette taille n'est pas la taille totale finale transférée.

## 6. Téléchargement et validation indépendante

La sauvegarde a été téléchargée/déchiffrée avec :

```bash
sudo mkdir -p /var/tmp/lodge-restore-test-20261018_1116
sudo rclone copy lodgecrypt:daily/2026-10-18_1116 /var/tmp/lodge-restore-test-20261018_1116 --transfers 2
```

Une vérification Python a comparé les SHA-256 aux originaux de `/var/backups/lodge/2026-10-18_1116`, lu intégralement les flux gzip et parcouru les tar, sans extraction ni affichage des données.

| Fichier | Résultat |
| --- | --- |
| `azuriom.tar.gz` | SHA-256 identique ; tar lisible, 12 333 entrées |
| `config.tar.gz` | SHA-256 identique ; tar lisible, 323 entrées |
| `grants.sql.gz` | SHA-256 identique ; gzip valide |
| `lodge_core.sql.gz` | SHA-256 identique ; gzip valide |
| `lodgecraft_web.sql.gz` | SHA-256 identique ; gzip valide |
| `panel.sql.gz` | SHA-256 identique ; gzip valide |
| `minecraft/661d00ad-99f7-4980-8497-85aad7750337.tar.gz` | SHA-256 identique ; tar lisible, 1 576 entrées |

Résultat : **7 fichiers attendus, zéro erreur**. Cela valide récupération, déchiffrement et intégrité de ce jeu de fichiers ; pas l'import SQL ni le fonctionnement du jeu après restauration.

Le dossier de test contient des données déchiffrées sensibles. Le conserver à accès restreint et le nettoyer après les tests. La capacité à récupérer la configuration Rclone et les clés de déchiffrement après perte totale du VPS n'a pas été validée ; prévoir une conservation sécurisée distincte, jamais dans Git.

## 7. Vérifications restantes

1. Après la prochaine nuit, contrôler les cinq backups dans Pterodactyl, leur date, taille et succès.
2. Après la fin du transfert prévu à 03:30 UTC, lire `/var/log/lodge-backup.log`, vérifier le nouveau dossier distant et les cinq serveurs représentés.
3. Valider les délais `save-on` et la récupération après échec ; prévoir un mécanisme plus fiable si nécessaire.
4. Vérifier les limites/rétentions de chaque serveur Pterodactyl, le disque disponible et la duplication des archives dans chaque journée.
5. Tester un import SQL et une restauration Minecraft dans un environnement isolé, sans écraser la production ni exposer les anciens secrets.
6. Vérifier les options de cohérence des dumps et la correspondance temporelle SQL/mondes.
7. Diagnostiquer les notifications `ServerInstalled` en échec, sans les confondre avec les sauvegardes réussies.
8. Vérifier les alertes en cas d'échec : un cron qui écrit un log n'est pas une notification automatique d'incident.

Le premier backup Survival reste conservé jusqu'à validation de la première nuit. Sa suppression ultérieure doit passer par le panel pour garder sa base synchronisée.

## 8. Versionnement conseillé

Conserver ce document dans `LodgeNetwork`, par exemple `docs/operations/sauvegardes-2026-10-18.md`. Ce rapport ne constitue pas une copie de l'ensemble des scripts actifs du VPS.

À versionner après revue : unité pteroq, modèle cron, scripts de sauvegarde nettoyés de leurs secrets et documentation de restauration. Les scripts publiés doivent lire leurs secrets dans une configuration externe, avec seulement un fichier d'exemple vide dans Git.

Ne jamais versionner `.env`, `rclone.conf`, clés Backblaze/de chiffrement, dumps SQL, exports de comptes, archives Minecraft, fichiers `.bak` ni dossiers téléchargés pour restauration.

Les modifications décrites ici concernent l'infrastructure, pas un nouveau commit du dépôt de plugins. Le patch RankMenu mentionné dans le bilan de Claude reste une intervention distincte dont le commit/push n'est pas confirmé par ce travail.
