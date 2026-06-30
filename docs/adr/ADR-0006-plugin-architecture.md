# ADR-0006 — Plugin Architecture

## Status

Accepted

## Context

Tous les plugins LodgeNetwork doivent partager la même architecture.

## Decision

Chaque plugin est indépendant.

Chaque plugin dépend uniquement de LodgeAPI.

Les plugins ne communiquent jamais directement entre eux.

Toute communication passe par des interfaces publiques de LodgeAPI.

## Avantages

- faible couplage
- maintenance facilitée
- possibilité de remplacer un plugin sans casser les autres
- tests plus simples
