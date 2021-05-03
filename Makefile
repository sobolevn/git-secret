SHELL:=/usr/bin/env bash
PREFIX?="/usr"
DESTDIR?=

#
# Building:
#

git-secret: src/version.sh src/_utils/*.sh src/commands/*.sh src/main.sh
	cat $^ > "$@"; \
	chmod +x git-secret; sync

.PHONY: all
all: build

.PHONY: clean
clean:
	rm -f git-secret

.PHONY: build
build: git-secret

.PHONY: install
install:
	chmod +x "./utils/install.sh"; sync; \
	"./utils/install.sh" "${DESTDIR}${PREFIX}"

.PHONY: uninstall
uninstall:
	chmod +x "./utils/uninstall.sh"; sync; \
	"./utils/uninstall.sh" "${DESTDIR}${PREFIX}"

#
# Testing and linting:
#

# The $(shell echo $${PWD}) construct is to access *nix paths under windows
# Under git for windows '$PATH' is set to windows paths, e.g. C:\Something
# Using a sub-shell we get the raw *nix paths, e.g. /c/Something
.PHONY: test
test: clean build
	chmod +x "./utils/tests.sh"; sync; \
	export SECRET_PROJECT_ROOT="$(shell echo $${PWD})"; \
	export PATH="$(shell echo $${PWD})/vendor/bats-core/bin:$(shell echo $${PWD}):$(shell echo $${PATH})"; \
	"./utils/tests.sh"

# We use this script in CI and you can do this too!
# What happens here?
# 1. We pass `GITSECRET_DOCKER_ENV` variable into this job
# 2. Based on it, we select a proper `docker` image to run test on
# 3. We execute `make test` inside the `docker` container
.PHONY: docker-ci
docker-ci: clean
	docker build \
		-f ".ci/docker/$${GITSECRET_DOCKER_ENV}/Dockerfile" \
		-t "gitsecret-$${GITSECRET_DOCKER_ENV}:latest" \
		.
	docker run --rm \
		--volume="$${PWD}:/code" \
		-w /code \
		"gitsecret-$${GITSECRET_DOCKER_ENV}" \
		make test

.PHONY: lint-shell
lint-shell:
	docker pull koalaman/shellcheck:latest
	docker run \
		--volume="$${PWD}:/code" \
		-w /code \
		-e SHELLCHECK_OPTS='-s bash -S warning -a' \
		--rm koalaman/shellcheck \
		$$(find src .ci utils tests -type f \
			-name '*.sh' -o -name '*.bash' -o -name '*.bats')

.PHONY: lint-docker
lint-docker:
	docker pull hadolint/hadolint:latest-alpine
	docker run \
		--volume="$${PWD}:/code" \
		-w /code \
		--rm hadolint/hadolint \
		hadolint \
			--ignore=DL3008 --ignore=DL3018 --ignore=DL3041 \
			.ci/docker/*/Dockerfile

.PHONY: lint
lint: lint-shell lint-docker

#
# Manuals:
#

.PHONY: clean-man
clean-man:
	find "man/" -type f -name "*.roff" -delete

.PHONY: build-man
build-man: clean-man git-secret
	# Prepare:
	touch man/*/*.ronn

	# Build docker image:
	docker pull msoap/ruby-ronn

	# Do the manual generation:
	GITSECRET_VERSION=`./git-secret --version` docker run \
		--volume="$${PWD}:/code" \
		-w /code \
		--rm msoap/ruby-ronn \
		ronn --roff \
			--organization=sobolevn \
			--manual="git-secret $${GITSECRET_VERSION}" \
			man/*/*.ronn

#
# Packaging:
#

.PHONY: install-fpm
install-fpm:
	if [ ! `gem list fpm -i` == "true" ]; then gem install fpm; fi

# .apk:

.PHONY: build-apk
build-apk: clean build install-fpm
	chmod +x "./utils/build-utils.sh"; sync; \
	chmod +x "./utils/apk/apk-build.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/apk/apk-build.sh"

.PHONY: test-apk-ci
test-apk-ci: build-apk
	chmod +x "./utils/apk/apk-ci.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats-core/bin:${PATH}"; \
	"./utils/apk/apk-ci.sh"

.PHONY: deploy-apk
deploy-apk: build-apk
	chmod +x "./utils/apk/apk-deploy.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/apk/apk-deploy.sh"

# .deb:

.PHONY: build-deb
build-deb: clean build install-fpm
	chmod +x "./utils/build-utils.sh"; sync; \
	chmod +x "./utils/deb/deb-build.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/deb/deb-build.sh"

.PHONY: test-deb-ci
test-deb-ci: build-deb
	chmod +x "./utils/deb/deb-ci.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats-core/bin:${PATH}"; \
	"./utils/deb/deb-ci.sh"

.PHONY: deploy-deb
deploy-deb: build-deb
	chmod +x "./utils/deb/deb-deploy.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/deb/deb-deploy.sh"

# .rpm:

.PHONY: build-rpm
build-rpm: clean build install-fpm
	chmod +x "./utils/build-utils.sh"; sync; \
	chmod +x "./utils/rpm/rpm-build.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/rpm/rpm-build.sh"

.PHONY: test-rpm-ci
test-rpm-ci: build-rpm
	chmod +x "./utils/rpm/rpm-ci.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	export PATH="${PWD}/vendor/bats-core/bin:${PATH}"; \
	"./utils/rpm/rpm-ci.sh"

.PHONY: deploy-rpm
deploy-rpm: build-rpm
	chmod +x "./utils/rpm/rpm-deploy.sh"; sync; \
	export SECRET_PROJECT_ROOT="${PWD}"; \
	"./utils/rpm/rpm-deploy.sh"
