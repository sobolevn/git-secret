#
# Building:
#

all: build

git-secret: src/_utils/* src/commands/* src/main.sh
	@cat $^ > "$@"
	@chmod +x git-secret

clean:
	@rm -f git-secret

build: git-secret

#
# Testing:
#

install-test:
	git clone https://github.com/sstephenson/bats.git vendor/bats

test:
	@if [ ! -d "vendor/bats" ]; then make install-test; fi
	@export SECRET_PROJECT_ROOT="${PWD}"; export PATH="${PWD}/vendor/bats/bin:${PWD}:${PATH}"; \
	make develop; \
	rm -rf temp; mkdir temp; cd temp; \
	bats "../tests";

#
# Manuals:
#

install-ronn:
	@if [ ! `gem list ronn -i` == "true" ]; then gem install ronn; fi

build-man:
	@make install-ronn
	ronn --roff man/man1/*.ronn

build-gh-pages:
	@/usr/bin/env bash utils/gh-branch.sh

#
# Development:
#

install-hooks:
	@# pre-commit:
	@ln -fs "${PWD}/utils/pre-commit.sh" "${PWD}/.git/hooks/pre-commit"
	@chmod +x "${PWD}/.git/hooks/pre-commit"
	@# post-commit:
	@ln -fs "${PWD}/utils/post-commit.sh" "${PWD}/.git/hooks/post-commit"
	@chmod +x "${PWD}/.git/hooks/post-commit"

develop: clean build install-hooks

#
# Packaging:
#

install-fpm:
	@if [ ! `gem list fpm -i` == "true" ]; then gem install fpm; fi

build-deb: clean build
	@make install-fpm
	@chmod +x "${PWD}/utils/build-deb.sh"
	@"./utils/build-deb.sh"

