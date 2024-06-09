current_dir:=$(shell pwd)

.PHONY: setup
setup:
	poetry config virtualenvs.in-project true
	poetry update
	poetry install --no-interaction --no-ansi

.PHONY: clear-env
clear-env:
	rm -rf .venv
	rm -rf venv
	poetry env remove --all

.PHONY: pretty
pretty:
	poetry run isort --profile black .
	poetry run black .

.PHONY: checkpretty
checkpretty:
	poetry run isort --profile black --check-only .
	poetry run black --check .

.PHONY: test
test:
	poetry run pytest ./tests -s

