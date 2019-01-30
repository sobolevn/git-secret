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

### Environment CentOS/RedHat (in development)

All steps should be performed as normal non-root user unless 'sudo' shown.

- sudo yum group install 'Development Tools'
- sudo yum install rubygem-bundler openssl-devel readline-devel zlib-devel docker
- set up docker for use as a normal user. You may have to put yourself in a special group, 
  and/or use sudo to change group ownership of /var/run/docker.sock
 -- see https://docs.docker.com/install/linux/linux-postinstall/ for more
- install rvm, see https://rvm.io/rvm/install
- change your dotfiles to add to $PATH and setup the rbenv environmentscript as shown during rvm install
- install ruby 2.4 with 'rbenv install 2.4.4' and 'rbenv local 2.4.4'
- gem install bundler kitchen-ansible serverspec kitchen-docker kitchen-verifier-serverspec

### Basic Kitchen Use

You should now be able to see the available kitchen test configurations for git-secret using:

- kitchen list

Git-secret kitchen test configurations have names like 'gnupg2-ubuntu-latest' and 'gnupg-git-ubuntu-rolling'.

to run a particular test, use the command

- bundle exec kitchen verify --test-base-path="$PWD/.ci/integration"  configuration-name-here

Using the command `kitchen` by itself will show you several of the capabilities it has.
You can read more about Test Kitchen at <https://github.com/test-kitchen/test-kitchen/blob/master/README.md>
and <https://kitchen.ci>

### Getting started

1. Create your own or pick an opened issue from the [tracker][tracker]. Take a look at the [`help-wanted` tag][help-wanted]
2. Fork and clone your repository: `git clone https://github.com/${YOUR_NAME}/git-secret.git`
3. Make sure that everything works on the current platform by running `make test`
4. [Run local CI tests](#running-local-ci-tests) to verify functionality on all tested platforms `bundle exec kitchen verify --test-base-path="$PWD/.ci/integration"`. Follow the command with a configuration name (as shown above) 

### Development Process

1. Firstly, you will need to setup development hooks with `make install-hooks`
2. Make changes to the files that need to be changed
3. When making changes to any files inside `src/` you will need to rebuild the binary `git-secret` with `make clean && make build` command
4. Run [`shellcheck`][shellcheck] against all your changes with `make lint`
5. Now, add all your files to the commit with `git add --all` and commit changes with `git commit`, make sure you write a good message, which will explain your work
6. When running `git commit` the tests will run automatically, your commit will be canceled if they fail
7. Push to your repository, make a pull-request against `master` branch. Please, make sure you have **one** commit per pull-request, it will be merge into one anyways

### Branches

We have two long-live branches: `master` and `gh-pages` for static web site.

It basically looks like this:

> `your-branch` -> `master`

- `master` branch is protected. So only fully tested code goes there. It is also used to create a new `git` tag and a `github` release

### Continuous integration

Local CI is done with the help [`test-kitchen`](http://kitchen.ci/). `test-kitchen` handles multiple test-suites on various platforms.
`bundle exec kitchen list` will output the list of test suites to be run against supported platforms.

Cloud CI is done with the help of `travis`. `travis` handles multiple environments:

- `Docker`-based jobs or so-called 'integration tests', these tests create a local release, install it with the package manager and then run unit-tests and system checks
- `OSX` jobs, which handle basic unit-tests on `OSX`
- Native `travis` jobs, which handle basic unit-tests and style checks

### Running local ci-tests

1. Install required gems with `bundle install`.
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

#### About GnuPG

Here are some links to gnupg documentation that might be useful for those working with git-secret:

- [GnuPG PDF Documentation](https://www.gnupg.org/documentation/manuals/gnupg.pdf)
- [GnuPG doc/DETAILS File](https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob;f=doc/DETAILS)

#### Travis releases

After you commit a tag that matches the pattern '^v.*$' and the tests succeed, Travis should publish new `deb` and `rpm` packages to [`bintray`][bintray].

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

### Downstream Packages

There are several distibutions and packaging systems that may already have git-secret packaged for your distribution (although sometimes their versions are not the most current, and we recommend all users upgrade to 0.2.5 or above). 

### Notes to Downstream Packagers (Those who make packages for specific OSes/distributions)

First of all, thank you for packaging git-secret for your platform! We appreciate it.

We also would like to welcome you to collaborate or discuss any issues, ideas or thoughts you have about 
git-secret by submitting issue report (which can also be feature requests) or pull requests via the git repo at 
[git-secret on github](https://github.com/sobolevn/git-secret) 

Please let us know if there are any changes you'd like to see to the source, 
packaging, testing, documentation, or other aspect of git-secret. 
We look forward to hearing from you.

## Financial contributions

We also welcome financial contributions in full transparency on our [open collective](https://opencollective.com/git-secret).
Anyone can file an expense. If the expense makes sense for the development of the community, it will be "merged" in the ledger of our open collective by the core contributors and the person who filed the expense will be reimbursed.


## Credits


### Contributors

Thank you to all the people who have already contributed 
to git-secret via commits to our git repository!
<a href="http://github.com/sobolevn/git-secret/graphs/contributors"><img src="https://opencollective.com/git-secret/contributors.svg?width=890" /></a>


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
