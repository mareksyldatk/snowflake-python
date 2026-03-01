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
4. Run `sql/setup/bootstrap_git_repository.sql`.

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
- Secret: `GITHUB_PAT_SECRET`
- Git repository object: `PLATFORM_DEV.INTEGRATION.REPO_SNOWFLAKE_PYTHON`
- Procedure: `PLATFORM_DEV.PYTHON.DEMO_REPO_PY()`

## Notes

1. To enable secret-based fetching later (non-trial accounts):
   1. Create required `SECRET` objects in `PLATFORM_DEV.SECURITY` and grant `READ` to `ROLE_DEV_PYTHON`.
   2. Create an external access integration and grant `USAGE` to `ROLE_DEV_PYTHON`.
   3. Recreate `PLATFORM_DEV.PYTHON.DEMO_REPO_PY()` with `EXTERNAL_ACCESS_INTEGRATIONS` and `SECRETS` mappings.
   4. In `src/demo_snowflake.py`, read mapped aliases via `_snowflake.get_generic_secret_string(...)`.
   5. Optionally hash secret values before returning/logging them.

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
