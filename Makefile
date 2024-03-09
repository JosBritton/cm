.SILENT:
.DEFAULT_GOAL := all

ROLES := dns dhcp

ANSIBLE_HOST_KEY_CHECKING := "False"
export ANSIBLE_HOST_KEY_CHECKING

# typical `make clean install` is not needed with this configuration
.PHONY: all
all: install

.PHONY: install
install: lint .venv/lock
	. .venv/bin/activate && \
	python3 -m ansible playbook -i inventory/hosts.yml site.yml

.PHONY: verbose
verbose: lint .venv/lock
	. .venv/bin/activate && \
	python3 -m ansible playbook -i inventory/hosts.yml site.yml -vvv

.PHONY: $(ROLES)
$(ROLES): lint .venv/lock
	. .venv/bin/activate && \
	python3 -m ansible playbook -i inventory/hosts.yml site.yml --tags "$@"

.PHONY: lint
lint: .venv/lock .git/hooks/pre-commit
	. ./.venv/bin/activate && \
	python3 -m ansiblelint --force-color

.PHONY: clean
clean:
	rm -rf .venv/
	rm -rf .state/

.venv/lock: requirements.txt
	python3 -m venv .venv/

	. .venv/bin/activate && \
	python3 -m pip install -U -r requirements.txt

	touch .venv/lock

.git/hooks/pre-commit: .pre-commit-config.yaml .venv/lock
	. .venv/bin/activate && \
	pre-commit install && \
	touch .git/hooks/pre-commit
