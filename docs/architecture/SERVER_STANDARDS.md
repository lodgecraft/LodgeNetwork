# Ressources et standards — 18 octobre 2026

## Instances

| Instance logique | Logiciel | Port | RAM conteneur |
| --- | --- | ---: | --- |
| proxy-01 | Velocity | 25565 | **1024 Mo (1 Go), confirmé par l'exploitant** |
| lobby-01 | Paper 1.21.8 | 25566 | Ancienne référence 1024 Mo, allocation active à confirmer |
| survival-01 | Paper 1.21.8 | 25567 | Ancienne référence 3072 Mo, allocation active à confirmer |
| build-01 | Paper 1.21.8 | 25569 | Ancienne référence 1024 Mo, allocation active à confirmer |
| discord-bot | Bot Discord | 25568 | À relever dans Pterodactyl |

Velocity n'est plus à 512/588 Mo. La JVM utilise `MaxRAMPercentage=95` selon le bilan fourni ; surveiller aussi la mémoire native du processus, pas uniquement le heap. La somme des limites des conteneurs n'est pas une preuve de RAM disponible sur l'hôte.

## Runtime et noms

Convention logique `type-index` ; les noms effectifs du panel peuvent différer. Minecraft utilise Java 21 pour les versions 1.21.8 documentées, image de référence `ghcr.io/pterodactyl/yolks:java_21`. Ne pas appliquer cette image au bot sans vérifier son runtime.

## Source de vérité

Git conserve la configuration souhaitée, les procédures et modèles sans secrets. Pterodactyl, les configurations chargées et les logs décrivent l'état effectif ; toute divergence doit être réconciliée et documentée. Git ne change pas automatiquement les allocations du panel.
