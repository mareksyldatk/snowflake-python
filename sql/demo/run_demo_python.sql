-- Minimal demo: run Python from this Git-backed repository in Snowflake.
-- Assumes these were already run:
-- 1) sql/setup/bootstrap_dev.sql
-- 2) sql/setup/bootstrap_current_user_permissions.sql
-- 3) sql/setup/bootstrap_git_integration.sql
-- 4) sql/setup/bootstrap_app_secrets.sql

USE ROLE ROLE_DEV_PYTHON;
USE WAREHOUSE WH_DEV_PYTHON;
USE DATABASE PLATFORM_DEV;

ALTER GIT REPOSITORY PLATFORM_DEV.INTEGRATION.REPO_SNOWFLAKE_PYTHON FETCH;

-- Optional check:
LS @PLATFORM_DEV.INTEGRATION.REPO_SNOWFLAKE_PYTHON/branches/main;

USE SCHEMA PLATFORM_DEV.PYTHON;

CREATE OR REPLACE PROCEDURE DEMO_REPO_PY()
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.12'
PACKAGES = ('snowflake-snowpark-python')
EXTERNAL_ACCESS_INTEGRATIONS = (EAI_DEV_PYTHON)
IMPORTS = (
  '@PLATFORM_DEV.INTEGRATION.REPO_SNOWFLAKE_PYTHON/branches/main/src/demo_snowflake.py'
)
SECRETS = (
  'client_id' = PLATFORM_DEV.SECURITY.CLIENT_ID,
  'client_secret' = PLATFORM_DEV.SECURITY.CLIENT_SECRET,
  'jwt_assertion' = PLATFORM_DEV.SECURITY.JWT_ASSERTION
)
HANDLER = 'run'
AS
$$
import demo_snowflake

def run(session):
    return demo_snowflake.run(session)
$$;

CALL DEMO_REPO_PY();
