-- Minimal demo: run Python from this Git-backed repository in Snowflake.
-- Assumes these were already run:
-- 1) sql/bootstrap_prod.sql
-- 2) sql/bootstrap_git_integration.sql
-- 3) GRANT ROLE ROLE_PROD_PYTHON TO USER <YOUR_SNOWFLAKE_USERNAME>;

USE ROLE ROLE_PROD_PYTHON;
USE WAREHOUSE WH_PROD_PYTHON;
USE DATABASE ANALYTICS_PROD;

ALTER GIT REPOSITORY ANALYTICS_PROD.INTEGRATION.REPO_SNOWFLAKE_PYTHON FETCH;

-- Optional check:
LS @ANALYTICS_PROD.INTEGRATION.REPO_SNOWFLAKE_PYTHON/branches/main;

USE SCHEMA ANALYTICS_PROD.PYTHON;

CREATE OR REPLACE PROCEDURE DEMO_REPO_PY()
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.12'
PACKAGES = ('snowflake-snowpark-python')
IMPORTS = (
  '@ANALYTICS_PROD.INTEGRATION.REPO_SNOWFLAKE_PYTHON/branches/main/demo_snowflake.py'
)
HANDLER = 'run'
AS
$$
import demo_snowflake

def run(session):
    return demo_snowflake.run(session)
$$;

CALL DEMO_REPO_PY();
