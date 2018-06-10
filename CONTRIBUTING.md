# Contributing

Your contributions are always welcome!

## Process

### Environment

Before starting make sure you have:

- git
- bash
- bundler
- docker
- gawk
- gnupg (or gnupg2)
- ruby
- sha256sum
- [shellcheck](https://github.com/koalaman/shellcheck)
- test-kitchen

Only required if dealing with manuals, `gh-pages` or releases:

- ruby, ruby-dev

### Environment MacOS

- install Docker for Mac
- install Chef Developer Kit
- install Homebrew
- install ruby2.4 and kitchen dependencies with `brew install rbenv ruby-build rbenv-vars; rbenv install 2.4.4; rbenv rehash; rbenv global 2.4.4 ;gem install bundler kitchen-ansible serverspec kitchen-docker kitchen-verifier-serverspec`

### Getting started

1. Create your own or pick an opened issue from the [tracker][tracker]. Take a look at the [`help-wanted` tag][help-wanted]
2. Fork and clone your repository: `git clone https://github.com/${YOUR_NAME}/git-secret.git`
3. Make sure that everything works on the current platform by running `make test`
4. [Run local CI tests](#running-local-ci-tests) to verify functionality on supported platforms `bundle exec kitchen verify --test-base-path="$PWD/.ci/integration"`.

### Development Process

1. Firstly, you will need to setup development hooks with `make install-hooks`
2. Make changes to the files that need to be changed
3. When making changes to any files inside `src/` you will need to rebuild the binary `git-secret` with `make clean && make build` command
4. Run [`shellcheck`][shellcheck] against all your changes with `make lint`
5. Now, add all your files to the commit with `git add --all` and commit changes with `git commit`, make sure you write a good message, which will explain your work
6. When running `git commit` the tests will run automatically, your commit will be canceled if they fail
7. Push to your repository, make a pull-request against `develop` branch. Please, make sure you have **one** commit per pull-request, it will be merge into one anyways

### Branches

We have three long-live branches: `master`, `develop` and `gh-pages` for static site.

It basically looks like that:

> `your-branch` -> `develop` -> `master`

- `master` branch is protected. So only fully tested code goes there. It is also used to create a new `git` tag and a `github` release
- `develop` is where the development is done and the branch you should send your pull-requests to

### Continuous integration

Local CI is done with the help [`test-kitchen`](http://kitchen.ci/). `test-kitchen` handles multiple test-suites on various platforms.
`bundle exec kitchen list` will output the list of test suites to be run aginst supported platforms.

Cloud CI is done with the help of `travis`. `travis` handles multiple environments:

- `Docker`-based jobs or so-called 'integration tests', these tests create a local release, install it with the package manager and then run unit-tests and system checks
- `OSX` jobs, which handle basic unit-tests on `OSX`
- Native `travis` jobs, which handle basic unit-tests and stylechecks

### Running local ci-tests

1. Install requied gems with `bundle install`.
2. Run ci-tests with `bundle exec kitchen verify --test-base-path="$PWD/.ci/integration"`

### Release process

The release process is defined in the `git`-hooks and `.travis.yml`.

When creating a commit inside the `master` branch (it is usually a documentation and changelog update with the version bump inside `src/version.sh`) it will trigger two main events.

Firstly, new manuals will be created and added to the current commit with `make build-man` on `pre-commit` hook.

Secondly, after the commit is successfully created it will also trigger `make build-gh-pages` target on `post-commit` hook, which will push new manuals to the [git-secret site][git-secret-site]. And the new `git` tag will be automatically created if the version is changed:

```bash
if [[ "$NEWEST_TAG" != "v${SCRIPT_VERSION}" ]]; then
  git tag -a "v${SCRIPT_VERSION}" -m "version $SCRIPT_VERSION"
fi
```

#### Travis releases

When creating a commit inside `master` branch, `travis` on successful build will publish new `deb` and `rpm` packages to [`bintray`][bintray].

If you wish to override a previous release (*be careful*) you will need to add `"override": 1` into `matrixParams`, see `deb-deploy.sh` and `rpm-deploy.sh`

#### Manual releases

Releases to `brew` are made manually.

#### Dockerhub releases

[`Dockerhub`][Dockerhub] contains `Docker` images with different OS'es used for testing. It is updated via a `github` webhook on commit into `master`.

[tracker]: https://github.com/sobolevn/git-secret/issues
[help-wanted]: https://github.com/sobolevn/git-secret/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22
[shellcheck]: https://github.com/koalaman/shellcheck
[git-secret-site]: http://git-secret.io
[bintray]: https://bintray.com/sobolevn
[Dockerhub]: https://hub.docker.com/r/sobolevn/git-secret/


## Financial contributions

We also welcome financial contributions in full transparency on our [open collective](https://opencollective.com/git-secret).
Anyone can file an expense. If the expense makes sense for the development of the community, it will be "merged" in the ledger of our open collective by the core contributors and the person who filed the expense will be reimbursed.


## Credits


### Contributors

Thank you to all the people who have already contributed to git-secret!
<a href="graphs/contributors"><img src="https://opencollective.com/git-secret/contributors.svg?width=890" /></a>


### Backers

Thank you to all our backers! [[Become a backer](https://opencollective.com/git-secret#backer)]

<a href="https://opencollective.com/git-secret#backers" target="_blank"><img src="https://opencollective.com/git-secret/backers.svg?width=890"></a>


### Sponsors

Thank you to all our sponsors! (please ask your company to also support this open source project by [becoming a sponsor](https://opencollective.com/git-secret#sponsor))

<a href="https://opencollective.com/git-secret/sponsor/0/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/1/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/2/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/3/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/4/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/5/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/6/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/7/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/8/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/9/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/9/avatar.svg"></a>