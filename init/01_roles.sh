#!/usr/bin/env bash
set -euo pipefail

psql -v ON_ERROR_STOP=1 \
  -v backend_pw="$BACKEND_DEV_PASSWORD" \
  -v bi_pw="$BI_DEV_PASSWORD" \
  -v de_pw="$DATA_ENGINEER_PASSWORD" \
  -U "$POSTGRES_USER" -d "$POSTGRES_DB" << 'EOF'
SELECT format('CREATE ROLE backend_dev LOGIN PASSWORD %L', :'backend_pw')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'backend_dev')\gexec

SELECT format('CREATE ROLE bi_dev LOGIN PASSWORD %L', :'bi_pw')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bi_dev')\gexec

SELECT format('CREATE ROLE data_engineer LOGIN PASSWORD %L', :'de_pw')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'data_engineer')\gexec
EOF
