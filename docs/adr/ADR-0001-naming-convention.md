# ADR-0001 — Naming convention

## Status

Accepted

## Context

LodgeNetwork doit pouvoir évoluer d’un seul VPS vers plusieurs nodes sans devoir renommer toute l’infrastructure.

## Decision

Les composants sont nommés selon leur rôle, avec un suffixe numérique.

Exemples :

- proxy-01
- lobby-01
- survival-01
- dev-01
- build-01
- event-01
- panel-01
- node-01
- db-01
- redis-01

## Consequences

- Les noms restent valides même si la technologie change.
- Il sera possible d’ajouter proxy-02, lobby-02 ou node-02 plus tard.
- La documentation reste claire et scalable.
