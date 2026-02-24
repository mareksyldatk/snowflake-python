# snowflake-python
Snowflake + Python Demo

## Repository layout

- `src/demo_snowflake.py`: Python handler used by the demo procedure.
- `sql/setup/`: one-time Snowflake setup scripts.
- `sql/demo/run_demo_python.sql`: recurring demo execution script.

## Snowflake quick start

One-time setup:
1. Run `sql/setup/bootstrap_prod.sql`.
2. Grant runtime role to your user:
   `GRANT ROLE ROLE_PROD_PYTHON TO USER <YOUR_SNOWFLAKE_USERNAME>;`
3. In `sql/setup/bootstrap_git_integration.sql`, replace `<YOUR_GITHUB_CLASSIC_PAT>`, then run it.
4. Run `sql/setup/bootstrap_git_repository.sql`.

Recurring demo run:
1. Run `sql/demo/run_demo_python.sql`.
2. Optional check:
   `SELECT * FROM ANALYTICS_PROD.PYTHON.DEMO_RANDOM_DATA ORDER BY CREATED_AT DESC LIMIT 50;`

## Snowflake objects created

- Role: `ROLE_PROD_PYTHON`
- Warehouse: `WH_PROD_PYTHON` (`XSMALL`)
- Database: `ANALYTICS_PROD`
- Schemas: `ANALYTICS_PROD.PYTHON`, `ANALYTICS_PROD.INTEGRATION`, `ANALYTICS_PROD.SECURITY`
- API integration: `GITHUB_INT_SNOWFLAKE_PYTHON`
- Secret: `GITHUB_PAT_SECRET`
- Git repository object: `ANALYTICS_PROD.INTEGRATION.REPO_SNOWFLAKE_PYTHON`
- Procedure: `ANALYTICS_PROD.PYTHON.DEMO_REPO_PY()`

## Python setup

```bash
# Create/update the pyenv virtualenv (default: 3.12.5)
./scripts/setup_python.sh

# Or pick a specific Python version
./scripts/setup_python.sh 3.12.6

# Activate the environment
pyenv activate snowflake-python

# (Optional) Reinstall dependencies
python -m pip install -r requirements.txt
```
