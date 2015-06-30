     _____  ___  _____  _____  ____   _____
    /  _  \/___\/  _  \|  _  \/  _/  /   __\
    |  _  <|   ||  |  ||  |  ||  |---|   __|
    \_____/\___/\__|__/|_____/\_____/\_____/

# bindle

`bindle` is a configuration management tool for your personal unix-like
computer.

## Goals & Philosophy

The core goal of `bindle` is to provide an easy way to manage a single
user's configuration, particularly:

- dotfiles,
- user binaries and scripts (ie, anything in `$HOME/bin`),
- configuration scripts.

In order to keep everything easy to understand, the structure of a
`bindle`-managed repository reflects the original locations of the tracked
files and the commands try to be as close to simple automation of the
underlying git commands as possible.

`bindle` is intended to compliment rather than entirely relace manual
configuration and versioning. Sometimes a local configuration might not
change for months or even years, so relearning a tool every time you want
to make a configuration change could be unnecessary overhead. `bindle` was
designed around a logical repository directory structure that works
great with or without the `bindle` program.

In order to be as portable as possible while still being easy to develop,
`bindle` is written in Bash and should work with the default Bash version
on any modern unix-like system (specifically, Bash 3 and higher). [Bash
"Strict Mode"](https://github.com/alphabetum/bash-boilerplate#bash-strict-mode)
and [ShellCheck](http://www.shellcheck.net/about.html) are used in development
to help ensure correctness.

See [alphabetum/dotfiles](https://github.com/alphabetum/dotfiles) for an
example of a configuration managed with `bindle`.

## Usage

The basic idea is that you can add dotfiles and user scripts to the
`~/.bindle` respository so they can be versioned, and symbolic links are
created in their original locations pointing to the versioned files.

The `bindle` command automates much of this by automatically moving, linking,
and listing the files you want to version, and it also provides shortcuts
for some git operations. Additionally, `bindle` can help version and run local
configuration scripts that you might want to create, like scripts for
installing local programs or libraries with package managers or scripts
for setting preferences.

### Installation

#### Homebrew

To install with [Homebrew](http://brew.sh/):

    brew tap alphabetum/taps && brew install alphabetum/taps/bindle

#### bpkg

To install with [bpkg](http://www.bpkg.io/):

    bpkg install alphabetum/bindle

#### Manual

To install manually, simply add the `bindle` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

    curl -L https://raw.github.com/alphabetum/hosts/master/bindle \
      -o ~/bin/bindle && chmod +x ~/bin/bindle

### Viewing Help Information

You can view the usage and help information by running `bindle` with no
arguments or with the `--help` or `-h` options.

### init

If you don't currently have a local repository tracking your dotfiles,
you can create one using

    bindle init

This will initialize a git repository at `$HOME/.bindle` with the following
structure:

    ~/.bindle
    ├── .gitignore
    ├── home/
    ├── bin/
    ├── local/
    └── script/
        ├── bootstrap/
        ├── configure/
        ├── customize/
        └── install/

You can change the location used for storing dotfiles by adding a
`.bindlerc` file at `$HOME/.bindlerc` and setting the `$BINDLEPATH` variable to
the desired location:

    export BINDLEPATH="/a/custom/path"

`bindle init` also creates a directory for local scripts at `$HOME/bin` if one
does not already exist.

### Overview

#### home

Contains all dotfiles and directories from `$HOME` that have been added to the
repository.

The `bindle` command assumes that any items at the root level of this directory
are 1) dotfiles (files and directories with a `.` prefix like `.bashrc` or
`.vim`) and 2) normally exist at your `$HOME` path, aka `~/`, which is the
root level of your user account's home directory.

To track items from `$HOME`, use `bindle add`:

    bindle add .bashrc

This adds the file or directory to `BINDLEPATH/home` and creates a symbolic link
in `$HOME` referencing the file or directory.

Once you've added a file, you need to commit it to the repository.

    bindle commit

Which will `git add` the changed files and do a `git commit`. See `bindle
help commit` for more information.

If you want to stop tracking a dotfile or directory, run `bindle restore`:

    bindle restore .bashrc

This removes the symbolic link in `$HOME` and copies the original file back to
`$HOME` from `$BINDLEPATH/home`.

###### Example

An example `bindle`-managed home directory:

[alphabetum/dotfiles/home](https://github.com/alphabetum/dotfiles/tree/master/home)

#### bin

Contains all scripts from `$HOME/bin` that have been added to the
repository.

Similar to `home`, all files at the root level of this directory are assumed to
be under version control and referenced in symbolic links in
`$HOME/bin`.

To track items from `$HOME/bin`, use `bindle bin add` (note the 'bin'
command):

    bindle bin add script-name

This adds the script to `$BINDLEPATH/bin` and creates a symbolic link in
`$HOME/bin` referencing the file.

To save this change, run `bindle commit` just like with dotfiles.

To stop tracking an item, use `bindle bin restore`:

    bindle bin restore script-name

###### Example

An example `bindle`-managed bin directory:

[alphabetum/dotfiles/bin](https://github.com/alphabetum/dotfiles/tree/master/bin)

#### local

This directory is excluded from the git repository, and therefore can be
used for storing things related to the configuration that you don't want
to track and don't want in the default directories.

#### script

`script` contains several subdirectories for contriguration scripts.
Scripts or programs in these directories can be written in any language and
can be run either individually or in aggregate. `bindle` makes no assumptions
about any of the scripts in these directories and will simply run them.

###### Example

An example `bindle`-managed script directory:

[alphabetum/dotfiles/script
](https://github.com/alphabetum/dotfiles/tree/master/script)

##### bootstrap

`bootstrap` should contain scripts for bootstrapping the user account
and user-controlled parts of the system. For example, bootstrap scripts
could set up some default folders and/or call a series of `install`,
`configure`, and `customize` scripts. Generally, a bootstrap script
should only be called once, during an initial setup.

To run a bootstrap script, use the `bindle bootstrap` command. For example:

    bindle bootstrap ubuntu

For more information, see `bindle help bootstrap`

###### Example

An example `bindle`-managed bootstrap directory with scripts:

[alphabetum/dotfiles/script/bootstrap
](https://github.com/alphabetum/dotfiles/tree/master/script/bootstrap)

##### install

`install` should contain scripts for installing programs, ideally via
package management systems. For example, you could have a bash script
that contains commands for installing programs via a system-wide package
manager like [homebrew](http://brew.sh/) or a language-specific one like
[LuaRocks](http://luarocks.org/).

To run an install script, use the `bindle install` command. For example:

    bindle install gems.sh

You can also run all of the install scripts by using the `--all` flag:

    bindle install --all

For more information, see `bindle help install`

###### Example

An example `bindle`-managed install directory with scripts:

[alphabetum/dotfiles/script/install
](https://github.com/alphabetum/dotfiles/tree/master/script/install)

##### configure

`configure` is intended for scripts that run perform system
configuration operations, like setting OS X preferences.

To run a configure script, use the `bindle configure` command. For example:

    bindle configure osx.sh

You can also run all of the configure scripts by using the `--all` flag:

    bindle configure --all

For more information, see `bindle help configure`

###### Example

An example `bindle`-managed configure directory with scripts:

[alphabetum/dotfiles/script/configure
](https://github.com/alphabetum/dotfiles/tree/master/script/configure)

##### customize

`customize` is intended for scripts that customize any aspect of the
configuration or anything else on the system. In other words, 'hacks'.
For example, I use it for changing icons on installed applications.

To run a customize script, use the `bindle customize` command. For example:

    bindle customize app_icons.py

You can also run all of the customize scripts by using the `--all` flag:

    bindle customize --all

For more information, see `bindle help customize`

###### Example

An example `bindle`-managed customize directory with scripts:

[alphabetum/dotfiles/script/customize
](https://github.com/alphabetum/dotfiles/tree/master/script/customize)

#### .gitignore

`.gitignore` is particularly useful for excluding sensitive information
from directories in the repository. For example, by default, `bindle`
excludes everything in any added `.ssh` directory except for the
`.ssh/config`.

It's also useful for dot directories that have both config files and
large temp or cache files. For example, a `.rbenv` directory for the
[rbenv](https://github.com/sstephenson/rbenv) tool contains both
configuration files and entire Ruby installations that are many
gigabytes in size. You can use `.gitignore` to exclude the ruby
installation directories while tracking the configuration files.

#### Git Commands

`bindle` has several commands to make it easier to perform git operations
on the `$BINDLEPATH` repository. Among these are:

- `bindle pull`
- `bindle push`
- `bindle submodules`
- `bindle git`

Use the help command (`bindle help <command-name>`) to learn more about
these.

#### Other Commands

`bindle` includes several other commands for performing operations on
files and inspecting the current state of the repository. All commands
can be viewed by running:

    bindle commands

To view the help and usage information for any command, use:

    bindle help <command-name>

## More Resources

- [alphabetum/dotfiles](https://github.com/alphabetum/dotfiles)
- [alphabetum/dotfile-research](https://github.com/alphabetum/dotfile-research)

