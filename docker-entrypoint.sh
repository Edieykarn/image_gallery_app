#!/bin/bash
set -e

# Remove any existing server PID file
rm -f /app/tmp/pids/server.pid

echo "🐘 Waiting for PostgreSQL to be ready..."
until pg_isready -h db -p 5432 -U postgres; do
  echo "Database is unavailable - sleeping"
  sleep 2
done
echo "✅ PostgreSQL is ready!"

echo "🗄️ Setting up database..."
bundle exec rails db:create 2>/dev/null || echo "Database already exists"

echo "🔄 Running migrations..."
bundle exec rails db:migrate

echo "🌱 Loading sample data (if available)..."
bundle exec rails db:seed 2>/dev/null || echo "No seed data or already seeded"

echo "🚀 Starting Rails application..."
exec "$@"