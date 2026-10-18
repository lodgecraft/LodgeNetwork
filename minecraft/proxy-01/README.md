# proxy-01 — Velocity

Entrée publique : `play.lodgecraft.fr:25565`.

RAM conteneur : **1024 Mo (1 Go)**, confirmée le 18 octobre 2026. L'ancienne valeur de 512 Mo est obsolète. Paramètre JVM rapporté : `MaxRAMPercentage=95` ; vérifier la marge native. Anciennes références CPU 100 % et disque 1 Go : non revalidées.

Backends : Lobby 25566, Survival 25567, Build 25569 ; forwarding modern. Secrets exclus de Git.

Build à la demande : [spécification](../../docs/architecture/BUILD_ON_DEMAND.md), non déployée.
