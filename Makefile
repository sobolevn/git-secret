SHELL:=/usr/bin/env bash
PREFIX?="/usr"

#
# Building:
#

.PHONY: all
all: build

git-secret: src/_utils/* src/commands/* src/main.sh
	@cat $^ > "$@"
	@chmod +x git-secret

.PHONY: clean
clean:
	@rm -f git-secret

.PHONY: build
build: git-secret

.PHONY: install
install:
	@chmod +x "./utils/install.sh"
	@"./utils/install.sh" "${PREFIX}"

#
# Testing:
#

.PHONY: install-test
install-test:
	git clone https://github.com/sstephenson/bats.git vendor/bats

.PHONY: test
test:
	@if [ ! -d "vendor/bats" ]; then make install-test; fi
	@export SECRET_PROJECT_ROOT="${PWD}"; export PATH="${PWD}/vendor/bats/bin:${PWD}:${PATH}"; \
	make develop; \
	rm -rf temp; mkdir temp; cd temp; \
	bats "../tests";

#
# Manuals:
#

.PHONY: install-ronn
install-ronn:
	@if [ ! `gem list ronn -i` == "true" ]; then gem install ronn; fi

.PHONY: build-man
build-man:
	@make install-ronn
	ronn --roff man/*/*.ronn

.PHONY: build-gh-pages
build-gh-pages:
	@chmod +x "./utils/gh-branch.sh"
	@"./utils/gh-branch.sh"

#
# Development:
#

.PHONY: install-hooks
install-hooks:
	@# pre-commit:
	@ln -fs "${PWD}/utils/pre-commit.sh" "${PWD}/.git/hooks/pre-commit"
	@chmod +x "${PWD}/.git/hooks/pre-commit"
	@# post-commit:
	@ln -fs "${PWD}/utils/post-commit.sh" "${PWD}/.git/hooks/post-commit"
	@chmod +x "${PWD}/.git/hooks/post-commit"

.PHONY: develop
develop: clean build install-hooks

#
# Packaging:
#

.PHONY: install-fpm
install-fpm:
	@if [ ! `gem list fpm -i` == "true" ]; then gem install fpm; fi

.PHONY: build-deb
build-deb: clean build
	@make install-fpm
	@chmod +x "./utils/build-deb.sh"
	@"./utils/build-deb.sh"

