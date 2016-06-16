SHELL:=/usr/bin/env bash
PREFIX?="/usr"

#
# Building:
#

git-secret: src/version.sh src/_utils/* src/commands/* src/main.sh
	@cat $^ > "$@"; \
	chmod +x git-secret; sync

.PHONY: all
all: build

.PHONY: clean
clean:
	@rm -f git-secret

.PHONY: build
build: git-secret

.PHONY: install
install:
	@chmod +x "./utils/install.sh"; sync; \
	"./utils/install.sh" "${PREFIX}"

#
# Testing:
#

.PHONY: install-test
install-test:
	@if [ ! -d "vendor/bats" ]; then \
	git clone https://github.com/sstephenson/bats.git vendor/bats; fi

.PHONY: test
test: install-test clean build
	@chmod +x "./utils/tests.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats/bin:${PWD}:${PATH}"; \
	"./utils/tests.sh"

#
# Manuals:
#

.PHONY: install-ronn
install-ronn:
	@if [ ! `gem list ronn -i` == "true" ]; then gem install ronn; fi

.PHONY: build-man
build-man: install-ronn
	@ronn --roff man/*/*.ronn

.PHONY: build-gh-pages
build-gh-pages:
	@chmod +x "./utils/gh-branch.sh"; sync; \
	"./utils/gh-branch.sh"

#
# Development:
#

.PHONY: install-hooks
install-hooks:
	@ln -fs "${PWD}/utils/hooks/pre-commit.sh" "${PWD}/.git/hooks/pre-commit"; \
	chmod +x "${PWD}/.git/hooks/pre-commit"; sync; \
	ln -fs "${PWD}/utils/hooks/post-commit.sh" "${PWD}/.git/hooks/post-commit"; \
	chmod +x "${PWD}/.git/hooks/post-commit"; sync

.PHONY: develop
develop: clean build install-hooks

#
# Packaging:
#

.PHONY: install-fpm
install-fpm:
	@if [ ! `gem list fpm -i` == "true" ]; then gem install fpm; fi

# .deb:

.PHONY: build-deb
build-deb: clean build install-fpm
	@chmod +x "./utils/build-utils.sh"; sync; \
	chmod +x "./utils/deb/deb-build.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/deb/deb-build.sh"

.PHONY: test-deb-ci
test-deb-ci: install-test build-deb
	@chmod +x "./utils/deb/deb-ci.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats/bin:${PATH}"; \
	"./utils/deb/deb-ci.sh"

.PHONY: deploy-deb
deploy-deb: build-deb
	@chmod +x "./utils/deb/deb-deploy.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/deb/deb-deploy.sh"

# .rpm:

.PHONY: build-rpm
build-rpm: clean build install-fpm
	@chmod +x "./utils/build-utils.sh"; sync; \
	chmod +x "./utils/rpm/rpm-build.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/rpm/rpm-build.sh"

.PHONY: test-rpm-ci
test-rpm-ci: install-test build-rpm
	@chmod +x "./utils/rpm/rpm-ci.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats/bin:${PATH}"; \
	"./utils/rpm/rpm-ci.sh"

.PHONY: deploy-rpm
deploy-rpm: build-rpm
	@chmod +x "./utils/rpm/rpm-deploy.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/rpm/rpm-deploy.sh"
