#!/usr/bin/env bash
set -euo pipefail

ENV_NAME="snowflake-python"
PYTHON_VERSION="${1:-3.12.5}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REQUIREMENTS_FILE="$REPO_ROOT/requirements.txt"
PYENV_ROOT_DIR="${PYENV_ROOT:-$HOME/.pyenv}"
PYTHON_INSTALL_DIR="$PYENV_ROOT_DIR/versions/$PYTHON_VERSION"

if ! command -v pyenv >/dev/null 2>&1; then
  echo "Error: pyenv is not installed or not in PATH."
  exit 1
fi

if ! pyenv commands | grep -qx "virtualenv"; then
  echo "Error: pyenv-virtualenv is not available. Install pyenv-virtualenv first."
  exit 1
fi

if [[ ! -d "$PYTHON_INSTALL_DIR" ]]; then
  echo "Installing Python $PYTHON_VERSION via pyenv..."
  pyenv install "$PYTHON_VERSION"
else
  reinstall_python="n"
  read -r -p "Python install exists at $PYTHON_INSTALL_DIR. Reinstall it? [y/N]: " reinstall_python

  if [[ "$reinstall_python" =~ ^([yY]|[yY][eE][sS])$ ]]; then
    echo "Reinstalling Python $PYTHON_VERSION via pyenv..."
    pyenv install -f "$PYTHON_VERSION"
  else
    echo "Keeping existing Python $PYTHON_VERSION."
  fi
fi

if pyenv virtualenvs --bare | grep -qx "$ENV_NAME"; then
  echo "Virtualenv '$ENV_NAME' already exists."
else
  echo "Creating virtualenv '$ENV_NAME' with Python $PYTHON_VERSION..."
  pyenv virtualenv "$PYTHON_VERSION" "$ENV_NAME"
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv activate "$ENV_NAME"
python -m pip install --upgrade pip setuptools wheel
if [[ -f "$REQUIREMENTS_FILE" ]]; then
  echo "Installing dependencies from $REQUIREMENTS_FILE..."
  python -m pip install -r "$REQUIREMENTS_FILE"
else
  echo "No requirements.txt found at $REQUIREMENTS_FILE"
fi
pyenv deactivate

echo "Done."
echo "To use it: pyenv activate $ENV_NAME"
