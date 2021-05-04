# Contributing

Your contributions are always welcome!


## Getting started

1. Create your own or pick an opened issue from the [tracker](https://github.com/sobolevn/git-secret/issues). Take a look at the [`help-wanted` tag](https://github.com/sobolevn/git-secret/labels/help%20wanted)

2. Fork the git-secret repo and then clone the repository using a command like `git clone https://github.com/${YOUR_NAME}/git-secret.git`

3. Make sure that everything works on the current platform by running `make test`.
   You can also try the experimental `SECRETS_TEST_VERBOSE=1 make test`, which will
   show you a lot of debug output while the tests are running.
   Note that 'experimental' features may change or be removed in a future version of `git-secret`.

4. If you want to test on multiple operating systems just push your PR, GitHub Actions will cover everything else

Basically, our `make` file is the only thing you will need to work with this repo.


## Process

### Environment

For development of `git-secret` you should have these tools locally:

- git
- bash
- gawk
- gnupg (or gnupg2), see below if not packaged by your distribution/OS (i.e. MacOS)
- sha256sum (on freebsd and MacOS `shasum` is used instead)
- make

To test `git-secret` you will need:

- [docker](https://www.docker.com/)

### Code style

New features and changes should aim to be as clear, concise, simple, and consistent

1. clear: make it as obvious as possible what the code is doing

2. concise: your PR should be as few characters (not just lines) of changes as _reasonable_.
   However, generally choose clarity over being concise.
   Clarity and conciseness can be in conflict with each other. But
   it's more important for the code to be understandable than for it to be small.
   Therefore favor writing clear code over making shorter diffs in your PRs.

3. simple: this dovetails with the previous two items.
   git-secret is a security product, so it's best to have the code be easy to understand.
   This also aids future development and helps minimize bugs.

4. consistent: Write code that is consistent with the surrounding code and the rest of the git-secret code base.
   Every code base has its own conventions and style that develop and accrete over time.

   Consistency also means that the inputs and outputs of git-secret should be as consistent as reasonable
   with related Unix and git tools, and follow the 'rule of least surprise',
   also known as the 'principle of least astonishment': <https://en.wikipedia.org/wiki/Principle_of_least_astonishment>

We wrote this to clarify our thinking about how git-secret should be written.  Of course, these are philosophical goals,
not necessities for releasing code, so balancing these four ideals _perfectly_ is both unwarranted and impossible.

### Writing PRs

If you're planning a large change to `git-secret` (for example, a lot of lines/characters of diffs, affecting multiple commands,
changing/adding a lot of behavior, or adding multiple command-line options), it's best to discuss the changes in an Issue first.
Also it's often best to implement larger or complex changes as a series of planned-out, smaller PRs,
each making a small set of specific changes. This facilitates discussions of implementation, which often come to light
only after seeing the actual code used to perform a task.

As mentioned above, we seek to be consistent with surrounding git and Unix tools, so when writing changes to git-secret,
think about the input, output, and command-line options that similar Unix commands use.

Our favor toward traditional Unix and git command-style inputs and outputs can also mean it's appropriate to
lean heavily on git and widely-used Unix command features instead of re-implementing them in code.

### Development Process

1. Firstly, you should setup git-secret's development git hooks with `make install-hooks`
This will copy the hooks from utils/hooks into .git/hooks/pre-commit and .git/hooks/post-commit

2. Make changes to the git secret files that need to be changed

3. When making changes to any files inside `src/`, for changes to take effect you will need to rebuild the `git-secret` script with `make clean && make build`

4. Run `shellcheck` against all your changes with `make lint`.
   You should also check your changes for spelling errors using 'aspell -c filename'.

5. Add an entry to CHANGELOG.md, referring to the related issue # if appropriate

6. Change the `man` source file(s) (we write them in markdown) in `man/man1` and `man/man7` to document your changes if appropriate

7. Now, add all your files to the commit with `git add --all` and commit changes with `git commit`.
   Write a good commit message which explains your work

8. When running `git commit` the tests will run automatically, your commit will be canceled if they fail.
   You can run the tests manually with `make clean build test`.
   If you want to make a commit and not run the pre- and post-commit hooks, use 'git commit -n'

9. Push to your repository, and make a pull-request against `master` branch. It's ideal to have one commit per pull-request,
but don't worry, it's easy to `squash` PRs into a small number of commits when they're merged.

### Branches

We have two long-live branches: `master` for the git-secret code and man pages, and `gh-pages` for the static web site.
The `gh-pages` branch tracks the `master` branch's `docs` folder, and is kept up-to-date using a GitHub Action.

Development looks like this:

> `your-branch` -> `master`

- `master` branch is protected, so only fully tested code goes there. It is also used to create a new `git` tag and a `github` release

By convention, you can name your branches like `issue-###-short-description`, but that's not required.
The `gh-pages` branch is used for the pages at `git-secret.io`. See 'Release Process' below.

### Writing tests

`git-secret` uses [bats-core](https://github.com/bats-core/bats-core) for testing.
See the files in tests/ and the `bats-core` documentation for details.

Because the output of many commands can be affected by the SECRETS_VERBOSE environment
variable (which enables verbosity), it's best not to expect a particular number of lines of
output from commands.

### Release process

To create a new release, (you'll first need permission to commit to the repo, of course):

Update the content of `CHANGELOG.md` for the release (this should be a matter of changing headers),
and update the version string in `src/version.sh`.

When creating a commit inside the `master` branch (it is usually a documentation and changelog update with the version bump inside `src/version.sh`).

Then, push your code to GitHub. It will start the CI.

After all the checks have executed, GitHub Actions will test and build releases for specific platforms.

While CI is doing it's building and testing, finish the release on github by pushing the new tag with:

```bash
git push --tags
```

and then go to https://github.com/sobolevn/git-secret/releases and 'draft a new release',
setting up a production release like the previous ones.

#### GitHub automated releases

TODO

#### Manual releases

Releases to `brew` are made manually, and involve opening a PR on the [Homebrew Core](https://github.com/Homebrew/homebrew-core) repo .
To get started, see the
[Homebrew docs about Formulae-related PRs](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request#formulae-related-pull-request)
and `brew bump-formula-pr --help`

### Downstream Packages

There are several distributions and packaging systems that may already have git-secret packaged for your distribution (although sometimes their versions are not the most current, and we recommend all users upgrade to 0.2.5 or above).

### Notes to Downstream Packagers (Those who make packages for specific OSes/distributions)

First of all, thank you for packaging git-secret for your platform! We appreciate it.

We also would like to welcome you to collaborate or discuss any issues, ideas or thoughts you have about
git-secret by submitting [issue report](https://github.com/sobolevn/git-secret/issues)
(which can also be feature requests) or
[pull requests](https://help.github.com/en/articles/creating-a-pull-request)
via the git repo at
[git-secret on github](https://github.com/sobolevn/git-secret)

Please let us know if there are any changes you'd like to see to the source,
packaging, testing, documentation, or other aspect of git-secret.
We look forward to hearing from you.


## About GnuPG

Here are some links to gnupg documentation that might be useful for those working with git-secret:

- [GnuPG PDF Documentation](https://www.gnupg.org/documentation/manuals/gnupg.pdf)
- [GnuPG doc/DETAILS File](https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=blob;f=doc/DETAILS)


## Financial contributions

We also welcome financial contributions in full transparency on our [open collective](https://opencollective.com/git-secret).
Anyone can file an expense. If the expense makes sense for the development of the community, it will be "merged" in the ledger of our open collective by the core contributors and the person who filed the expense will be reimbursed.


## Credits

### Contributors

Thank you to all the people who have already contributed
to `git-secret` via commits to our git repository!

[![List of contributors](https://opencollective.com/git-secret/contributors.svg?width=890&button=0)](https://github.com/sobolevn/git-secret/contributors)


### Backers

Thank you to all our backers! [[Become a backer](https://opencollective.com/git-secret#backer)]

<object type="image/svg+xml" data="https://opencollective.com/git-secret/tiers/backer.svg?avatarHeight=36&width=600" style="max-width: 100%;"></object>


### Sponsors

Thank you to all our sponsors! (please ask your company to also support this open source project by [becoming a sponsor](https://opencollective.com/git-secret#sponsor))

<object type="image/svg+xml" data="https://opencollective.com/git-secret/tiers/sponsor.svg?avatarHeight=36&width=600" style="max-width: 100%;"></object>
