# ADR-0005 — Git Strategy

## Status

Accepted

## Date

2026-07-01

## Context

Le dépôt Git est la source de vérité de LodgeNetwork.

Il doit permettre de reconstruire l'ensemble de la plateforme.

## Decision

Le dépôt contient :

- Infrastructure
- Documentation
- Eggs
- Configurations
- Plugins
- Scripts

Les données d'exécution (bases de données, logs, mondes Minecraft, sauvegardes) ne sont jamais versionnées.

## Branches

- main → production
- develop → développement
- feature/* → nouvelles fonctionnalités
- hotfix/* → corrections urgentes

## Commit

Les commits doivent être courts, explicites et atomiques.
