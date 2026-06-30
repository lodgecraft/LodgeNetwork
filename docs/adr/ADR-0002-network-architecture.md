# ADR-0002 — Network Architecture

## Status

Accepted

## Date

2026-07-01

## Context

LodgeNetwork est conçu comme un réseau Minecraft moderne basé sur un proxy, avec une architecture capable d'évoluer d'un seul VPS vers plusieurs nœuds sans modification majeure.

Le réseau doit être facilement extensible, documenté et reproductible.

## Decision

L'architecture retenue est la suivante :

```
                Internet
                     │
          play.lodgecraft.fr
                     │
                proxy-01
                     │
     ┌───────────────┼───────────────┐
     │               │               │
 lobby-01      survival-01      event-01
                     │
               ┌─────┴─────┐
               │           │
          build-01     dev-01
```

Le proxy est l'unique point d'entrée des joueurs.

Les serveurs backend ne sont jamais exposés directement à Internet.

Le réseau est pensé pour évoluer vers plusieurs nœuds physiques.

## Consequences

- Un seul port public Minecraft (25565).
- Les serveurs internes communiquent uniquement via Velocity.
- Les nouveaux serveurs pourront être ajoutés sans modifier l'architecture.
- Une migration vers plusieurs VPS sera simple.
