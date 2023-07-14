all: test

init-dev: ## Create and initialize a local virtual env for dev
	rm -rf venv
	python3 -m venv venv
	venv/bin/pip install --disable-pip-version-check -U pip
	venv/bin/pip install -r requirements-dev.txt

check-dirty:  ## Validate working copy is commited
	test -z "$$(git status -s)" || (echo "Uncommited changes, aborting."; exit 1)
	test -z "$$(git cherry -v)" || (echo "Unpushed changes, aborting."; exit 1)

lint:  ## Perform code sanity checks if needed
	find views -name "*.lkml" | xargs venv/bin/yamllint -c .yamllintconfig

validate: check-dirty ## Perform code sanity checks if needed
	./venv/bin/python tools/content_validator_min.py "$$(git rev-parse --abbrev-ref HEAD)" --run-project-validation

test: check-dirty ## Perform code sanity checks if needed
	./venv/bin/python tools/content_validator_min.py "$$(git rev-parse --abbrev-ref HEAD)" --run-lookml-tests

clean: ## Purge temporary files
	find . -name __pycache__ | xargs rm -rf
	find . -name '*,cover' -delete
	find . -name '*.swp' -delete

clean-all: clean ## Fully purge environment
	rm -rf .cache
	rm -rf venv

help:  ## Show this help.
	@grep -E "^[^._][a-zA-Z_-]*:" Makefile | awk -F '[:#]' '{print $$1, ":", $$NF}' | sort | column -t -s:

.SILENT: all check-dirty help lint
.PHONY: all help lint
