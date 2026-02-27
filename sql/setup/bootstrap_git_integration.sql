-- Snowflake Git Integration Bootstrap
--
-- Execute in order. Replace <YOUR_GITHUB_CLASSIC_PAT> before running.
-- For private GitHub repos, PAT typically needs classic `repo` scope.
-- This script can run before or after sql/setup/bootstrap_dev.sql.

-- ------------------------------------------------------------------
-- 1) Create API integration and required containers (ACCOUNTADMIN)
-- ------------------------------------------------------------------
-- Purpose:
-- Establish a Snowflake API integration that allows outbound HTTPS
-- calls to the specific GitHub repository prefix only.
-- Also ensure database/schemas required by this script exist.
-- Result:
-- Integration object GITHUB_INT_SNOWFLAKE_PYTHON is created/enabled
-- and scoped to the mareksyldatk/snowflake-python repo URL.
-- Secret and git objects can be created in dedicated schemas.
USE ROLE ACCOUNTADMIN;

-- Make script order-independent (can run before bootstrap_dev.sql)
CREATE DATABASE IF NOT EXISTS PLATFORM_DEV;
CREATE SCHEMA IF NOT EXISTS PLATFORM_DEV.SECURITY;
CREATE SCHEMA IF NOT EXISTS PLATFORM_DEV.INTEGRATION;

CREATE OR REPLACE API INTEGRATION GITHUB_INT_SNOWFLAKE_PYTHON
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = (
    'https://github.com/mareksyldatk/snowflake-python.git'
  )
  ALLOWED_AUTHENTICATION_SECRETS = ALL
  ENABLED = TRUE;

-- Allow SECURITYADMIN to manage secrets in dedicated SECURITY schema.
GRANT USAGE ON INTEGRATION GITHUB_INT_SNOWFLAKE_PYTHON TO ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE PLATFORM_DEV TO ROLE SECURITYADMIN;
GRANT USAGE ON SCHEMA PLATFORM_DEV.SECURITY TO ROLE SECURITYADMIN;
GRANT CREATE SECRET ON SCHEMA PLATFORM_DEV.SECURITY TO ROLE SECURITYADMIN;

-- ------------------------------------------------------------------
-- 2) Create secret with GitHub credentials (SECURITYADMIN)
-- ------------------------------------------------------------------
-- Purpose:
-- Store GitHub username + PAT in a Snowflake SECRET object so credentials
-- are not embedded in GIT REPOSITORY definitions.
-- Result:
-- Secret GITHUB_PAT_SECRET is available in PLATFORM_DEV.SECURITY.
-- Required action:
-- Replace <YOUR_GITHUB_CLASSIC_PAT> with a valid token before execution.
USE ROLE SECURITYADMIN;
USE DATABASE PLATFORM_DEV;
USE SCHEMA SECURITY;

CREATE OR REPLACE SECRET GITHUB_PAT_SECRET
  TYPE = PASSWORD
  USERNAME = 'mareksyldatk'
  PASSWORD = '<YOUR_GITHUB_CLASSIC_PAT>';
