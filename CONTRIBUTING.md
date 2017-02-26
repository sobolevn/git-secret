# Contributing

Your contributions are always welcome!

## Process

### Environment

Before starting make sure you have:

- git
- bash
- gnupg (or gnupg2)
- [shellcheck](https://github.com/koalaman/shellcheck)

Only required if dealing with manuals, `gh-pages` or releases:

- ruby, ruby-dev

### Getting started

1. Create your own or pick an opened issue from the [tracker][tracker]. Take a look at the [`help-wanted` tag][help-wanted]
2. Fork and clone your repository: `git clone https://github.com/${YOUR_NAME}/git-secret.git`
3. Make sure that everything works fine by running `make test`

### Development Process

1. Firstly, you will need to setup development hooks with `make install-hooks`
2. Make changes to the files that need to be changed
3. When making changes to any files inside `src/` you will need to rebuild the binary `git-secret` with `make clean && make build` command
4. Run [`shellcheck`][shellcheck] against all your changes with `make lint`
5. Now, add all your files to the commit with `git add --all` and commit changes with `git commit`, make sure you write a good message, which will explain your work
6. When running `git commit` the tests will run automatically, your commit will be canceled if they fail
7. Push to your repository, make a pull-request against `develop` branch. Please, make sure you have **one** commit per pull-request, it will be merge into one anyways

### Branches

We have three long-live branches: `master`, `staging` and `develop` (and `gh-pages` for static site).

It basically looks like that:

> `your-branch` -> `develop` -> `staging` -> `master`

- `master` branch is protected, since `antigen` and tools like it install the app from the main branch directly. So only fully tested code goes there
- `staging` - this branch is used to create a new `git` tag and a `github` release, then it gets merged into `master`
- `develop` is where the development is done and the branch you should send your pull-requests to

### Continuous integration

CI is done with the help of `travis`. `travis` handles multiple environments:

- `Docker`-based jobs or so-called 'integration tests', these tests create a local release, install it with the package manager and then run unit-tests and system checks
- `OSX` jobs, which handle basic unit-tests on `OSX`
- Native `travis` jobs, which handle basic unit-tests and stylechecks

### Release process

The release process is defined in the `git`-hooks and `.travis.yml`.

When creating a commit inside the `staging` branch (it is usually a documentation and changelog update with the version bump inside `src/version.sh`) it will trigger two main events.

Firstly, new manuals will be created and added to the current commit with `make build-man` on `pre-commit` hook.

Secondly, after the commit is successfully created it will also trigger `make build-gh-pages` target on `post-commit` hook, which will push new manuals to the [git-secret site][git-secret-site]. And the new `git` tag will be automatically created if the version is changed:

```bash
if [[ "$NEWEST_TAG" != "v${SCRIPT_VERSION}" ]]; then
  git tag -a "v${SCRIPT_VERSION}" -m "version $SCRIPT_VERSION"
fi
```

Then it will be merged inside `master` when ready.

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
