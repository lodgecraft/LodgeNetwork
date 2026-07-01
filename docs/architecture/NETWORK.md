# LodgeCraft Network Architecture

## Infrastructure

```
Internet
        │
        ▼
 play.lodgecraft.fr
        │
        ▼
+--------------------+
|    Velocity Proxy  |
|      proxy-01      |
|      Port 25565    |
+--------------------+
        │
        ├───────────────┐
        ▼               ▼
+---------------+   +----------------+
|   lobby-01    |   |  survival-01   |
|   Port 25566  |   |   Port 25567   |
+---------------+   +----------------+
```

---

## Current servers

| Name | Type | Port | Status |
|------|------|------|--------|
| proxy-01 | Velocity | 25565 | Production |
| lobby-01 | Paper | 25566 | Production |
| survival-01 | Paper | 25567 | Production |

---

## Network

External players connect only to:

```
25565
```

Backend servers are **never** accessed directly from the Internet.

Traffic flow:

```
Player
    │
    ▼
Velocity
    │
    ▼
Paper Servers
```

---

## Docker networking

Velocity communicates with backend servers using Docker DNS.

Current hostnames:

| Server | Docker hostname |
|---------|-----------------|
| lobby-01 | f6c3898e-5ad8-46c0-9492-75f9d26428da |
| survival-01 | db5a93b3-2dfe-4a41-b9b1-a5856a6eaf86 |

> Temporary solution.
>
> Future objective:
>
> Replace Docker UUIDs with stable container names or a dedicated Docker network.

---

## Security

### Public ports

- 22 → SSH
- 80 → HTTP
- 443 → HTTPS
- 25565 → Minecraft Proxy
- 2022 → Wings SFTP
- 8080 → Wings API

### Internal Minecraft ports

- 25566 → Lobby
- 25567 → Survival

Blocked from the Internet using the DOCKER-USER chain.

---

## Velocity

Forwarding mode:

```
modern
```

Secret:

```
Stored in forwarding.secret
```

Player IP logging:

```
Disabled
```

Query protocol:

```
Disabled
```

Player sample:

```
Disabled
```

---

## Future servers

Planned infrastructure:

- proxy-01
- lobby-01
- survival-01
- build-01
- minage-01
- events-01
- dev-01
- database
- redis
- website
- discord-bot

---

## Pterodactyl Docker DNS

Velocity currently connects to backend servers using Pterodactyl server UUIDs.

Example:

```toml
lobby = "f6c3898e-5ad8-46c0-9492-75f9d26428da:25566"
survival = "db5a93b3-2dfe-4a41-b9b1-a5856a6eaf86:25567"
