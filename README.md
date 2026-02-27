# snowflake-python
Snowflake + Python Demo

## Repository layout

- `src/demo_snowflake.py`: Python handler used by the demo procedure.
- `sql/setup/`: one-time Snowflake setup scripts.
- `sql/demo/run_demo_python.sql`: recurring demo execution script.

## Snowflake quick start

One-time setup:
1. Run `sql/setup/bootstrap_dev.sql`.
2. Run `sql/setup/bootstrap_current_user_permissions.sql`.
3. In `sql/setup/bootstrap_git_integration.sql`, replace `<YOUR_GITHUB_CLASSIC_PAT>`, then run it.
4. In `sql/setup/bootstrap_app_secrets.sql`, replace placeholders, then run it.
5. Run `sql/setup/bootstrap_git_repository.sql`.

Recurring demo run:
1. Run `sql/demo/run_demo_python.sql`.
2. Optional check:
   `SELECT * FROM PLATFORM_DEV.PYTHON.DEMO_RANDOM_DATA ORDER BY CREATED_AT DESC LIMIT 50;`

## Snowflake objects created

- Role: `ROLE_DEV_PYTHON`
- Warehouse: `WH_DEV_PYTHON` (`XSMALL`)
- Database: `PLATFORM_DEV`
- Schemas: `PLATFORM_DEV.PYTHON`, `PLATFORM_DEV.INTEGRATION`, `PLATFORM_DEV.SECURITY`
- API integration: `GITHUB_INT_SNOWFLAKE_PYTHON`
- External access integration: `EAI_DEV_PYTHON`
- Secret: `GITHUB_PAT_SECRET`
- App secrets: `CLIENT_ID`, `CLIENT_SECRET`, `JWT_ASSERTION`
- Git repository object: `PLATFORM_DEV.INTEGRATION.REPO_SNOWFLAKE_PYTHON`
- Procedure: `PLATFORM_DEV.PYTHON.DEMO_REPO_PY()`

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
