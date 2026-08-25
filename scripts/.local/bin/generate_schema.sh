#!/usr/bin/env bash

# Prompt for database details with smart defaults
read -rp "Database Name [mydb]: " DB_NAME
DB_NAME="${DB_NAME:-mydb}"

read -rp "Username [postgres]: " DB_USER
DB_USER="${DB_USER:-postgres}"

read -rp "Host [localhost]: " DB_HOST
DB_HOST="${DB_HOST:-localhost}"

read -rp "Port [5432]: " DB_PORT
DB_PORT="${DB_PORT:-5432}"

read -srp "Password (press Enter to skip): " DB_PASS
echo ""

OUTPUT_FILE="schema.sql"

if [ -f "$OUTPUT_FILE" ]; then
  read -rp "Overwriting existing '$OUTPUT_FILE'. Continue? (y/N): " CONFIRM
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

echo "Exporting schema..."

if PGPASSWORD="$DB_PASS" pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
  --schema-only \
  -F p \
  -f "$OUTPUT_FILE"; then
  echo "Success! Saved schema to: $OUTPUT_FILE"
else
  echo "Error: Failed to generate schema dump." >&2
  exit 1
fi
