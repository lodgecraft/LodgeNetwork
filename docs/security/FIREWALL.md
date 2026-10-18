# Pare-feu et accès — bilan du 18 octobre 2026

Le trafic entrant vers les conteneurs depuis `ens3` a été filtré par une liste blanche dans `DOCKER-USER` : entrée Minecraft 25565, avec limite annoncée de 10 connexions par IP, et votes 8192 ; autres ports conteneur bloqués. Règles enregistrées via netfilter-persistent et contrôlées après reboot selon le bilan de l'exploitant.

Cette description ne remplace pas le dump des règles et ne précise pas la sémantique exacte de la limite (débit ou connexions simultanées). Elle ne signifie pas que seuls deux ports existent sur l'hôte : SSH et Nginx relèvent notamment du trafic destiné à l'hôte.

UFW n'est pas la référence actuelle : iptables/netfilter-persistent sont utilisés. Contrôler INPUT et FORWARD/DOCKER-USER et préserver les échanges internes Docker, les connexions établies et la voie SSH.

SSH : authentification par mot de passe désactivée, priorité du fichier `50-cloud-init.conf` corrigée, résultat vérifié avec `sshd -T`.

Le forwarding secret protège l'identité transmise par Velocity ; il ne remplace pas l'isolation réseau des backends. Aucun secret ni règle appliquée aveuglément dans ce dépôt.
