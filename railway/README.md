# CostKey on Railway

1. **New project → Deploy a Docker image**: `ghcr.io/costkey/costkey:latest`.
2. **Add a service → Database → PostgreSQL**.
3. On the CostKey service, add variables:
   - `DATABASE_URL` = `${{Postgres.DATABASE_URL}}`
   - `COSTKEY_JWT_SECRET` and `COSTKEY_NOTIFICATION_ENCRYPTION_KEY`, each the output of `openssl rand -hex 32`
   - `NODE_ENV` = `production`
4. **Settings → Networking → Generate domain**, port 4100.

Open the domain and sign up. DSNs use the Railway domain until you set `PUBLIC_URL`.
