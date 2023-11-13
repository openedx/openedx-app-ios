#!/bin/bash

VENV_PATH="${SRCROOT}/venv"

if [ ! -d "$VENV_PATH" ]; then
    /usr/bin/python3 -m venv "$VENV_PATH"
fi

source "$VENV_PATH/bin/activate"

pip install --upgrade pip
pip install PyYAML

python process_config.py

deactivate
