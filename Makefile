.SILENT:
.DEFAULT_GOAL := all

ANSIBLE_HOST_KEY_CHECKING := "False"
export ANSIBLE_HOST_KEY_CHECKING

# typical `make clean install` is not needed with this configuration
.PHONY: all
all: install

.PHONY: install
install: lint .venv/lock
	. .venv/bin/activate && \
	python3 -m ansible playbook -i inventory/hosts.ini site.yml

.PHONY: lint
lint: .venv/lock
	. ./.venv/bin/activate && \
	./.venv/bin/ansible-lint .

.PHONY: clean
clean:
	rm -rf .venv/

.venv/lock: requirements.txt
	python3 -m venv .venv

	. .venv/bin/activate && \
	python3 -m pip install -U -r requirements.txt

	touch .venv/lock

