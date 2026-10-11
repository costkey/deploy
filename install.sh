#!/bin/sh
# Install self-hosted CostKey with Docker: Postgres, plus the server and
# console on one port.
#
#   curl -fsSL https://costkey.dev/install.sh | sh
#
# COSTKEY_DIR (default ./costkey), COSTKEY_PORT (default 4100) and
# COSTKEY_PUBLIC_URL (default http://localhost:<port>) change where it lives,
# its port and the address in DSNs. Running it again upgrades in place.
set -eu

DIR="${COSTKEY_DIR:-costkey}"
PORT="${COSTKEY_PORT:-4100}"
# The address people and SDKs use. Defaults to this machine.
PUBLIC_URL="${COSTKEY_PUBLIC_URL:-http://localhost:$PORT}"

if ! command -v docker >/dev/null 2>&1; then
  echo "CostKey runs on Docker. Install it first: https://docs.docker.com/get-docker/" >&2
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "CostKey needs Docker Compose v2 (the 'docker compose' command)." >&2
  exit 1
fi

secret() {
  if command -v openssl >/dev/null 2>&1; then openssl rand -hex 32
  else od -An -N32 -tx1 /dev/urandom | tr -d ' \n'; fi
}

mkdir -p "$DIR"
cd "$DIR"
curl -fsSL https://costkey.dev/self-host/docker-compose.yml -o docker-compose.yml

if [ ! -f .env ]; then
  umask 077
  cat > .env <<ENV
# Where people and SDKs reach this server. DSNs and email links use it.
PUBLIC_URL=$PUBLIC_URL
COSTKEY_PORT=$PORT
COSTKEY_JWT_SECRET=$(secret)
COSTKEY_NOTIFICATION_ENCRYPTION_KEY=$(secret)
POSTGRES_PASSWORD=$(secret)
# Optional: email for invites, alerts and summaries (Resend)
# RESEND_API_KEY=
# COSTKEY_NOTIFICATION_FROM=CostKey <alerts@your-domain.com>
ENV
  echo "Wrote $DIR/.env with new secrets. Keep it safe."
fi

docker compose pull
docker compose up -d

URL="$(grep '^PUBLIC_URL=' .env | cut -d= -f2-)"
printf "Starting CostKey"
i=0
until curl -fsS "http://localhost:$(grep '^COSTKEY_PORT=' .env | cut -d= -f2-)/health" >/dev/null 2>&1; do
  i=$((i + 1))
  if [ "$i" -gt 90 ]; then
    echo
    echo "CostKey did not come up. See: cd $DIR && docker compose logs costkey" >&2
    exit 1
  fi
  printf "."
  sleep 2
done
echo
echo "CostKey is running at $URL"
echo "Open it, sign up, and copy your project's DSN into your app."
