-- Role definitions are executed by 01_roles.sh with psql variables.
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'backend_dev') THEN
    CREATE ROLE backend_dev LOGIN PASSWORD :'backend_pw';
  END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bi_dev') THEN
    CREATE ROLE bi_dev LOGIN PASSWORD :'bi_pw';
  END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'data_engineer') THEN
    CREATE ROLE data_engineer LOGIN PASSWORD :'de_pw';
  END IF;
END
$$;
