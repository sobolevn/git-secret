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

.PHONY: uninstall
uninstall:
	@chmod +x "./utils/uninstall.sh"; sync; \
	"./utils/uninstall.sh" "${PREFIX}"

#
# Testing:
#

.PHONY: install-test
install-test:
	@if [ ! -d "vendor/bats-core" ]; then \
	git clone --depth 1 -b v1.0.2 https://github.com/bats-core/bats-core.git vendor/bats-core; \
	fi

.PHONY: test
test: install-test clean build
	@chmod +x "./utils/tests.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats-core/bin:${PWD}:${PATH}"; \
	"./utils/tests.sh"

#
# Manuals:
#

.PHONY: install-ronn
install-ronn:
	@if [ ! `gem list ronn -i` == "true" ]; then gem install ronn; fi

.PHONY: clean-man
clean-man:
	@find "man/" -type f ! -name "*.ronn" -delete

.PHONY: build-man
build-man: install-ronn clean-man
	@ronn --roff --organization="sobolevn" --manual="git-secret" man/*/*.ronn

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

.PHONY: lint
lint:
	@find src utils -type f -name '*.sh' -print0 | xargs -0 -I {} shellcheck {}

#
# Packaging:
#

.PHONY: install-fpm
install-fpm:
	@if [ ! `gem list fpm -i` == "true" ]; then gem install fpm; fi

# .apk:

.PHONY: build-apk
build-apk: clean build install-fpm
	@chmod +x "./utils/build-utils.sh"; sync; \
	chmod +x "./utils/apk/apk-build.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/apk/apk-build.sh"

.PHONY: test-apk-ci
test-apk-ci: install-test build-apk
	@chmod +x "./utils/apk/apk-ci.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats-core/bin:${PATH}"; \
	"./utils/apk/apk-ci.sh"

.PHONY: deploy-apk
deploy-apk: build-apk
	@chmod +x "./utils/apk/apk-deploy.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/apk/apk-deploy.sh"

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
	export PATH="${PWD}/vendor/bats-core/bin:${PATH}"; \
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
	export PATH="${PWD}/vendor/bats-core/bin:${PATH}"; \
	"./utils/rpm/rpm-ci.sh"

.PHONY: deploy-rpm
deploy-rpm: build-rpm
	@chmod +x "./utils/rpm/rpm-deploy.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/rpm/rpm-deploy.sh"

# make:

.PHONY: test-make-ci
test-make-ci: clean install-test
	@chmod +x "./utils/make/make-ci.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats-core/bin:${PATH}"; \
	"./utils/make/make-ci.sh"
