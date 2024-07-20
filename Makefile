.SILENT:
.DEFAULT_GOAL := all

ROLES := dns dhcp lb bt stork_agent

ANSIBLE_HOST_KEY_CHECKING := "False"
export ANSIBLE_HOST_KEY_CHECKING

.PHONY: all
all: notag

.PHONY: notag
notag: .venv/lock
	. .venv/bin/activate && \
	python3 -m ansible playbook -i inventory/hosts.yml site.yml

.PHONY: install
install: .git/hooks/pre-commit

.PHONY: verbose
verbose: .venv/lock
	. .venv/bin/activate && \
	python3 -m ansible playbook -i inventory/hosts.yml site.yml -vvv

.PHONY: $(ROLES)
$(ROLES): .venv/lock
	. .venv/bin/activate && \
	python3 -m ansible playbook -i inventory/hosts.yml site.yml --tags "$@"

.PHONY: lint
lint: .venv/lock .git/hooks/pre-commit
	. ./.venv/bin/activate && \
	python3 -m ansiblelint --force-color

.PHONY: clean
clean:
	(. .venv/bin/activate && pre-commit uninstall) || true
	rm -rf .venv/

.venv/lock: requirements.txt
	python3 -m venv .venv/

	. .venv/bin/activate && \
	python3 -m pip install -U -r requirements.txt

	touch .venv/lock

.git/hooks/pre-commit: .pre-commit-config.yaml .venv/lock
	. .venv/bin/activate && \
	pre-commit install && \
	touch .git/hooks/pre-commit
