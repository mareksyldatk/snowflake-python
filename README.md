# snowflake-python
Snowflake + Python Demo

## Snowflake Git integration

Use `sql/bootstrap_git_integration.sql` to create:
- API integration: `GITHUB_INT_SNOWFLAKE_PYTHON`
- Secret: `GITHUB_PAT_SECRET`

Before running, replace `<YOUR_GITHUB_CLASSIC_PAT>` in the script.
Configured repo URL: `https://github.com/mareksyldatk/snowflake-python.git`.
This repo will be used next as a Snowflake workspace for running Python scripts.

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
