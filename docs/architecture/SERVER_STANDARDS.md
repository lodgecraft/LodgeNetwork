# LodgeNetwork - Server Standards

## Naming

Tous les serveurs suivent la convention :

type-index

Exemples :

proxy-01
lobby-01
survival-01
build-01
dev-01
event-01

---

## Ports

25565 → Proxy

25566 → Lobby

25567 → Survival

25568 → Build

25569 → Dev

25570 → Event

---

## Java

Tous les serveurs utilisent :

Java 21

Docker Image :

ghcr.io/pterodactyl/yolks:java_21

---

## Egg

Les serveurs Paper utilisent exclusivement :

LodgeNetwork → Paper

Le proxy utilise :

LodgeNetwork → Velocity

---

## RAM

proxy-01      512 MB

lobby-01      1024 MB

survival-01   3072 MB

build-01      1024 MB

dev-01        1024 MB

event-01      512 MB

---

## Source of truth

Toutes les configurations sont documentées dans Git.

Le Panel Pterodactyl n'est jamais la source officielle.
