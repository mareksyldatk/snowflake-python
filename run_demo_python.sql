-- Demo: run Python from this Git-backed repository in Snowflake
--
-- Prerequisites:
-- 1) sql/bootstrap_prod.sql
-- 2) sql/bootstrap_git_integration.sql
--
-- This script can be rerun.

-- ------------------------------------------------------------------
-- 1) Ensure ROLE_PROD_PYTHON can use integration + secret
-- ------------------------------------------------------------------
USE ROLE ACCOUNTADMIN;
GRANT USAGE ON INTEGRATION GITHUB_INT_SNOWFLAKE_PYTHON TO ROLE ROLE_PROD_PYTHON;

USE ROLE SECURITYADMIN;
GRANT READ ON SECRET ANALYTICS_PROD.SECURITY.GITHUB_PAT_SECRET TO ROLE ROLE_PROD_PYTHON;

-- ------------------------------------------------------------------
-- 2) Create/fetch Git repository object
-- ------------------------------------------------------------------
USE ROLE ROLE_PROD_PYTHON;
USE WAREHOUSE WH_PROD_PYTHON;
USE DATABASE ANALYTICS_PROD;

CREATE OR REPLACE GIT REPOSITORY ANALYTICS_PROD.INTEGRATION.REPO_SNOWFLAKE_PYTHON
  API_INTEGRATION = GITHUB_INT_SNOWFLAKE_PYTHON
  GIT_CREDENTIALS = ANALYTICS_PROD.SECURITY.GITHUB_PAT_SECRET
  ORIGIN = 'https://github.com/mareksyldatk/snowflake-python.git';

ALTER GIT REPOSITORY ANALYTICS_PROD.INTEGRATION.REPO_SNOWFLAKE_PYTHON FETCH;

-- Optional: inspect fetched files.
LS @ANALYTICS_PROD.INTEGRATION.REPO_SNOWFLAKE_PYTHON/branches/main;

-- ------------------------------------------------------------------
-- 3) Create and run Python procedure from repo file
-- ------------------------------------------------------------------
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
