all: build

git-secret: src/_utils/* src/commands/* src/main.sh
	@cat $^ > "$@"
	@chmod +x git-secret

clean:
	@rm -f git-secret

build: git-secret

install-test:
	git clone https://github.com/sstephenson/bats.git vendor/bats

test:
	@if [ ! -d "vendor/bats" ]; then make install-test; fi
	@export SECRET_PROJECT_ROOT="${PWD}"; export PATH="${PWD}/vendor/bats/bin:${PWD}:${PATH}"; \
	make develop; \
	rm -rf temp; mkdir temp; cd temp; \
	bats ../tests;

install-man:
	gem install ronn

build-man:
	@if [ ! `gem list ronn -i` == "true" ]; then make install-man; fi
	ronn --roff man/man1/*.ronn

install-hooks:
	@ln -fs "${PWD}/utils/pre-commit.sh" "${PWD}/.git/hooks/pre-commit"
	@chmod +x "${PWD}/.git/hooks/pre-commit"

develop: clean build install-hooks
