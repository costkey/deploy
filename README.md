# Deploy CostKey

[CostKey](https://costkey.dev) shows cost, latency, failures and quality for every AI agent run, down to the line of code, with budgets, Slack alerts and a kill switch for runaway spend. It runs on your own infrastructure: one container (`ghcr.io/costkey/costkey`, for Intel and Apple Silicon) plus Postgres.

Once it's up, open it, sign up, and copy your project's DSN into your app with the [TypeScript](https://github.com/costkey/costkey) or [Python](https://github.com/costkey/costkey-python) SDK.

## One click

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/costkey/deploy)
[![Deploy to DigitalOcean](https://www.deploytodo.com/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/costkey/deploy/tree/main)

- **Render** creates the service and a Postgres, and generates the secrets ([`render.yaml`](render.yaml)).
- **DigitalOcean** creates the app and a Postgres; it asks for the two secrets ([`.do/deploy.template.yaml`](.do/deploy.template.yaml)).

## One command

**Your machine or any server** (Docker Compose with Postgres, on port 4100):

```bash
curl -fsSL https://costkey.dev/install.sh | sh
```

**Kubernetes:**

```bash
helm install costkey oci://ghcr.io/costkey/charts/costkey
```

**Google Cloud Run** (Cloud SQL, Secret Manager):

```bash
PROJECT=your-project REGION=us-central1 bash cloud-run/deploy.sh
```

**AWS** (one encrypted EC2 instance):

```bash
aws cloudformation deploy --stack-name costkey --template-file aws/costkey.yaml
```

## Step by step

| Where | Files |
| --- | --- |
| Docker Compose | [`docker-compose.yml`](docker-compose.yml), [`.env.example`](.env.example), [`install.sh`](install.sh) |
| Any VPS (DigitalOcean, Hetzner, Linode, Vultr) | [`cloud-init.yaml`](cloud-init.yaml) as the server's user data |
| Kubernetes | [`kubernetes/`](kubernetes) |
| Railway | [`railway/`](railway) |
| Fly.io | [`fly/fly.toml`](fly/fly.toml) |
| Google Cloud Run | [`cloud-run/deploy.sh`](cloud-run/deploy.sh) |
| AWS | [`aws/costkey.yaml`](aws/costkey.yaml) |

Full guide: [costkey.dev/docs/deploy](https://costkey.dev/docs/deploy/). Serverless hosts such as Vercel don't fit: CostKey keeps a database pool and runs background work (price sync, alerts, summaries).

## Settings

| Setting | What it does |
| --- | --- |
| `COSTKEY_JWT_SECRET` | Signs sign-in sessions. Required. |
| `COSTKEY_NOTIFICATION_ENCRYPTION_KEY` | Encrypts saved Slack and webhook URLs. Required. |
| `DATABASE_URL` | Postgres 14 or newer. |
| `PUBLIC_URL` | Where people and SDKs reach CostKey. Render, Railway and Fly.io fill it in. |
| `RESEND_API_KEY`, `COSTKEY_NOTIFICATION_FROM` | Optional email for invites, alerts and summaries. |

MIT licensed.
