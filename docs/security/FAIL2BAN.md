# Fail2Ban

## Jails actifs

- sshd
- nginx-http-auth
- lodge-nginx-scanners

## Protection

Le serveur bloque automatiquement :

- tentatives SSH
- authentification Nginx
- scans de :
  - .env
  - wp-admin
  - wp-login
  - phpmyadmin
  - adminer
  - .git
  - vendor
  - backup
  - install

## Vérification

```bash
sudo fail2ban-client status
sudo fail2ban-client status lodge-nginx-scanners
```
