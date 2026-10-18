# Déploiement et vérification

1. Relever l'état courant dans Pterodactyl et sauvegarder les fichiers concernés.
2. Compiler/tester les modules concernés ; identifier le commit et le JAR.
3. Arrêter le serveur concerné dans Pterodactyl avant de remplacer un JAR.
4. Déployer, redémarrer et contrôler logs, version et comportement.
5. En cas d'échec, arrêter, remettre la sauvegarde puis redémarrer.

Les scripts de modification doivent proposer une simulation par défaut et exiger `--apply` pour modifier. Ne jamais afficher les secrets ni les placer dans les arguments visibles ou dans Git.

La mise à jour de la documentation ne modifie pas le VPS. Les changements système doivent être vérifiés indépendamment. Pour une automatisation Build, ne jamais automatiser une fermeture pendant une sauvegarde/restauration ou ignorer le mode maintenance.
