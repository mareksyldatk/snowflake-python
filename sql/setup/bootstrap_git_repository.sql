-- First run bootstrap: create Snowflake Git repository object
-- Assumes:
-- 1) sql/setup/bootstrap_prod.sql
-- 2) sql/setup/bootstrap_git_integration.sql

USE ROLE ROLE_PROD_PYTHON;
USE DATABASE ANALYTICS_PROD;
USE SCHEMA INTEGRATION;

CREATE GIT REPOSITORY IF NOT EXISTS REPO_SNOWFLAKE_PYTHON
  API_INTEGRATION = GITHUB_INT_SNOWFLAKE_PYTHON
  GIT_CREDENTIALS = ANALYTICS_PROD.SECURITY.GITHUB_PAT_SECRET
  ORIGIN = 'https://github.com/mareksyldatk/snowflake-python.git';
