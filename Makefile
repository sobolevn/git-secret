SHELL:=/usr/bin/env bash
PREFIX?="/usr"
DESTDIR?=

#
# Building:
#

git-secret: src/version.sh src/_utils/*.sh src/commands/*.sh src/main.sh
	@cat $^ > "$@"
	@chmod +x git-secret; sync

.PHONY: all
all: build

.PHONY: clean
clean:
	@rm -f git-secret

.PHONY: build
build: git-secret

.PHONY: install
install:
	${SHELL} ./utils/install.sh "${DESTDIR}${PREFIX}"

.PHONY: uninstall
uninstall:
	${SHELL} ./utils/uninstall.sh "${DESTDIR}${PREFIX}"

#
# Testing and linting:
#

# The $(shell echo $${PWD}) construct is to access *nix paths under windows
# Under git for windows '$PATH' is set to windows paths, e.g. C:\Something
# Using a sub-shell we get the raw *nix paths, e.g. /c/Something
.PHONY: test
test: clean build
	export SECRET_PROJECT_ROOT="$(shell echo $${PWD})"; \
	export PATH="$(shell echo $${PWD})/vendor/bats-core/bin:$(shell echo $${PWD}):$(shell echo $${PATH})"; \
	${SHELL} ./utils/tests.sh

# We use this script in CI and you can do this too!
# What happens here?
# 1. We pass `GITSECRET_DOCKER_ENV` variable into this job
# 2. Based on it, we select a proper `docker` image to run test on
# 3. We execute `make test` inside the `docker` container
.PHONY: docker-ci
docker-ci: clean
	@[ -z "${GITSECRET_DOCKER_ENV}" ] \
		&& echo 'GITSECRET_DOCKER_ENV is unset' && exit 1 || true
	docker build \
		-f ".ci/docker-ci/$${GITSECRET_DOCKER_ENV}/Dockerfile" \
		-t "gitsecret-$${GITSECRET_DOCKER_ENV}:latest" .
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
		$$(find src .ci utils tests docs -type f \
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
			.ci/*/**/Dockerfile

.PHONY: lint
lint: lint-shell lint-docker

#
# Manuals and docs:
#

.PHONY: clean-man
clean-man:
	@find "man/" -type f ! -name "*.md" -delete

.PHONY: build-man
build-man: git-secret
	docker pull msoap/ruby-ronn
	export GITSECRET_VERSION="$$(./git-secret --version)" && docker run \
		--volume="$${PWD}:/code" \
		-w /code \
		--rm msoap/ruby-ronn \
		ronn --roff \
			--organization=sobolevn \
			--manual="git-secret $${GITSECRET_VERSION}" \
			man/*/*.md

.PHONY: build-docs
build-docs: build-man
	${SHELL} docs/create_posts.sh

.PHONY: docs
docs: build-docs
	docker pull jekyll/jekyll
	docker run \
		--volume="$${PWD}/docs:/code" \
		-w /code \
		-p 4000:4000 \
		--rm jekyll/jekyll \
		jekyll serve --safe --strict_front_matter

#
# Packaging:
#

.PHONY: release-build
release-build: clean build
	@[ -z "${GITSECRET_RELEASE_TYPE}" ] \
		&& echo 'GITSECRET_RELEASE_TYPE is unset' && exit 1 || true
	docker build \
		-f ".ci/releaser/alpine/Dockerfile" \
		-t "gitsecret-releaser:latest" .
	docker run \
		--volume="$${PWD}:/code" \
		--rm gitsecret-releaser \
		bash "./utils/$${GITSECRET_RELEASE_TYPE}/build.sh"

.PHONY: release
release: release-build
	docker run \
		--volume="$${PWD}:/code" \
		-e SECRETS_ARTIFACTORY_CREDENTIALS \
		--rm gitsecret-releaser \
		bash "./utils/$${GITSECRET_RELEASE_TYPE}/deploy.sh"
