#!/bin/bash
set -e

CONTAINER=paperclip

echo "🚀 Starting Paperclip stack..."
docker compose up -d

echo "⏳ Waiting for container to be ready..."
until docker exec $CONTAINER sh -c "pg_isready -h db -U ${POSTGRES_USER:-paperclip}" >/dev/null 2>&1; do
  sleep 2
done

echo "✅ Database is ready"

echo "📦 Running onboard..."
docker exec -it $CONTAINER pnpm paperclipai onboard || true

echo "👑 Bootstrapping CEO..."
docker exec -it $CONTAINER pnpm paperclipai auth bootstrap-ceo || true

echo "🎉 Done!"
echo "👉 Check logs above for invite URL"