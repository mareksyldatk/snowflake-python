# snowflake-python
Snowflake + Python Demo

## Snowflake Git integration

Use `sql/setup/bootstrap_git_integration.sql` to create:
- API integration: `GITHUB_INT_SNOWFLAKE_PYTHON`
- Secret: `GITHUB_PAT_SECRET`

Before running, replace `<YOUR_GITHUB_CLASSIC_PAT>` in the script.
Configured repo URL: `https://github.com/mareksyldatk/snowflake-python.git`.
This repo will be used next as a Snowflake workspace for running Python scripts.

## Snowflake runtime bootstrap

Use `sql/setup/bootstrap_prod.sql` to create:
- Role: `ROLE_PROD_PYTHON`
- Warehouse: `WH_PROD_PYTHON` (`XSMALL`)
- Database: `ANALYTICS_PROD` (if missing)
- Schemas: `ANALYTICS_PROD.PYTHON`, `ANALYTICS_PROD.INTEGRATION`, `ANALYTICS_PROD.SECURITY`

## Demo: run Python from this repo

Files:
- `src/demo_snowflake.py` (Python handler)
- `sql/demo/run_demo_python.sql` (fetches branch, creates procedure, calls it)

Run order in Snowflake:
1. `sql/setup/bootstrap_prod.sql`
2. `sql/setup/bootstrap_git_integration.sql`
3. `sql/setup/bootstrap_git_repository.sql` (first run only)
4. `sql/demo/run_demo_python.sql`

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
