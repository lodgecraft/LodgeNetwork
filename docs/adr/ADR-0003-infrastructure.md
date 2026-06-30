# ADR-0003 — Infrastructure

## Status

Accepted

## Date

2026-07-01

## Context

L'infrastructure doit être stable, reproductible et simple à maintenir.

## Decision

Le premier nœud de production utilise :

- Ubuntu 24.04 LTS
- Docker
- Pterodactyl Panel
- Wings
- MariaDB
- Redis
- Nginx
- PHP 8.3
- Java 21

Tous les composants sont documentés et versionnés.

## Consequences

Les futures mises à jour devront respecter cette architecture.

Toute modification importante fera l'objet d'un nouvel ADR.
