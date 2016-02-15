all: build

git-secret: src/_utils/* src/commands/* src/main.sh
	@cat $^ > "$@"
	@chmod +x git-secret

clean:
	@rm -f git-secret

build: git-secret

develop: clean build

install-test:
	git clone https://github.com/sstephenson/bats.git vendor/bats

test:
	@if [ ! -d "vendor/bats" ]; then make install-test; fi
	@export SECRET_PROJECT_ROOT="${PWD}"; export PATH="${PWD}/vendor/bats/bin:${PWD}:${PATH}"; \
	rm -rf temp; mkdir temp; cd temp; \
	bats ../tests;

install-man:
	gem install ronn

man:
	@if [ `gem list ronn -i` == "false" ]; then make install-man; fi
	ronn --roff man/*.ronn
