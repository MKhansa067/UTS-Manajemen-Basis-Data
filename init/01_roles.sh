#!/usr/bin/env bash
set -euo pipefail

psql -v ON_ERROR_STOP=1 \
  -v backend_pw="$BACKEND_DEV_PASSWORD" \
  -v bi_pw="$BI_DEV_PASSWORD" \
  -v de_pw="$DATA_ENGINEER_PASSWORD" \
  -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -f /docker-entrypoint-initdb.d/01_roles.sql
