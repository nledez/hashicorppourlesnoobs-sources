#!/bin/bash
VENV_PATH=.venv
PYTHON_BIN=python3

if [ ! -d ${VENV_PATH} ]; then
	virtualenv -p `which ${PYTHON_BIN}` ${VENV_PATH}
fi

.venv/bin/pip install -r requirements.txt
