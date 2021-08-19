#!/usr/bin/env bash

if [ ! -d ./venv ]; then
	python3 -m venv venv
fi

./venv/bin/pip freeze | grep selenium || ./venv/bin/pip install -r requirements.txt
