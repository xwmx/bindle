         _       _
        | |     | |
      __| | ___ | |_ ___
     / _` |/ _ \| __/ __|
    | (_| | (_) | |_\__ \
     \__,_|\___/ \__|___/

# dots

`dots` is a configuration management tool for your personal unix-like
computer.

## Goals & Philosophy

The core goal of `dots` is to provide an easy way to manage a single
user's configuration, particularly:

- dotfiles,
- user binaries and scripts (ie, anything in `$HOME/bin`),
- configuration scripts.

In order to keep everything easy to understand, the structure of a
`dots`-managed repository reflects the original locations of the tracked
files and the commands try to be as close to simple automation of the
underlying git commands as possible.

`dots` is intended to compliment rather than entirely relace manual
configuration and versioning. Sometimes a local configuration might not
change for months or even years, so relearning a tool every time you want
to make a configuration change could be unnecessary overhead. `dots` was
designed around a logical repository directory structure that works
great with or without the `dots` program.

In order to be as portable as possible while still being easy to develop,
`dots` is written in Bash and should work with the default Bash version
on any modern unix-like system (specifically, Bash 3 and higher).

See [alphabetum/dotfiles](https://github.com/alphabetum/dotfiles) for an
example of a configuration managed with `dots`.

## Usage

### Installation

To get started, add the `dots` script to your path.

#### Homebrew

To install with homebrew, use the following command:

    brew install alphabetum/taps/dots

### Usage

You can view the usage and help information by running `dots` with no
arguments or with the `--help` or `-h` options.

### init

If you don't currently have a local repository tracking your dotfiles,
you can create one using

    dots init

This will initialize a git repository at `$HOME/.dots` with the following
structure:

    ~/.dots
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
`.dotsrc` file at `$HOME/.dotsrc` and setting the `$DOTSPATH` variable to the
desired location:

    export DOTSPATH="/a/custom/path"

`dots init` also creates a directory for local scripts at `$HOME/bin` if one
does not already exist.

### Overview

#### home

Contains all dotfiles and directories from `$HOME` that have been added to the
repository.

The `dots` command assumes that any items at the root level of this directory
are 1) dotfiles (files and directories with a `.` prefix, ie, `.vim`) and 2)
all symlinked in `$HOME`. It makes no assumptions about any additional
subdirectories or unadded dotfiles. This is intended to be as simple as
possible to avoid ambiguity.

To track items from `$HOME`, use `dots add`:

    dots add .bashrc

This adds the file or directory to `$DOTFILES/home` and creates a symbolic link
in `$HOME` referencing the file or directory.

Once you've added a file, you need to commit it to the repository.

    dots commit

Which will `git add` the changed files and do a `git commit`. See `dots
help commit` for more information.

If you want to stop tracking a dotfile or directory, run `dots restore`:

    dots restore .bashrc

This removes the symbolic link in `$HOME` and copies the original file back to
`$HOME` from `$DOTFILES/home`.

###### Example

An example `dots`-managed home directory:

[alphabetum/dotfiles/home](https://github.com/alphabetum/dotfiles/tree/master/home)

#### bin

Contains all scripts from `$HOME/bin` that have been added to the
repository.

Similar to `home`, all files at the root level of this directory are assumed to
be under version control and referenced in symbolic links in
`$HOME/bin`.

To track items from `$HOME/bin`, use `dots bin add` (note the 'bin'
command):

    dots bin add script-name

This adds the script to `$DOTFILES/bin` and creates a symbolic link in
`$HOME/bin` referencing the file.

To save this change, run `dots commit` just like with dotfiles.

To stop tracking an item, use `dots bin restore`:

    dots bin restore script-name

###### Example

An example `dots`-managed bin directory:

[alphabetum/dotfiles/bin](https://github.com/alphabetum/dotfiles/tree/master/bin)

#### local

This directory is excluded from the git repository, and therefore can be
used for storing things related to the configuration that you don't want
to track and don't want in the default directories.

#### script

`script` contains three subdirectories for contriguration scripts.
Scripts or programs in this directory can be written in any language and can
be run either individually or in aggregate. `dots` makes no assumptions about
any of the scripts in these directories and will simply run them.

###### Example

An example `dots`-managed script directory:

[alphabetum/dotfiles/script
](https://github.com/alphabetum/dotfiles/tree/master/script)

##### bootstrap

`bootstrap` should contain scripts for bootstrapping the user account
and user-controlled parts of the system. For example, bootstrap scripts
could set up some default folders and/or call a series of `install`,
`configure`, and `customize` scripts. Generally, a bootstrap script
should only be called once, during an initial setup.

To run a bootstrap script, use the `dots bootstrap` command. For example:

    dots bootstrap ubuntu

For more information, see `dots help bootstrap`

###### Example

An example `dots`-managed bootstrap directory with scripts:

[alphabetum/dotfiles/script/bootstrap
](https://github.com/alphabetum/dotfiles/tree/master/script/bootstrap)

##### install

`install` should contain scripts for installing programs, ideally via
package management systems. For example, you could have a bash script
that contains commands for installing programs via a system-wide package
manager like [homebrew](http://brew.sh/) or a language-specific one like
[LuaRocks](http://luarocks.org/).

To run an install script, use the `dots install` command. For example:

    dots install gems.sh

You can also run all of the install scripts by using the `--all` flag:

    dots install --all

For more information, see `dots help install`

###### Example

An example `dots`-managed install directory with scripts:

[alphabetum/dotfiles/script/install
](https://github.com/alphabetum/dotfiles/tree/master/script/install)

##### configure

`configure` is intended for scripts that run perform system
configuration operations, like setting OS X preferences.

To run a configure script, use the `dots configure` command. For example:

    dots configure osx.sh

You can also run all of the configure scripts by using the `--all` flag:

    dots configure --all

For more information, see `dots help configure`

###### Example

An example `dots`-managed configure directory with scripts:

[alphabetum/dotfiles/script/configure
](https://github.com/alphabetum/dotfiles/tree/master/script/configure)

##### customize

`customize` is intended for scripts that customize any aspect of the
configuration or anything else on the system. In other words, 'hacks'.
For example, I use it for changing icons on installed applications.

To run a customize script, use the `dots customize` command. For example:

    dots customize app_icons.py

You can also run all of the customize scripts by using the `--all` flag:

    dots customize --all

For more information, see `dots help customize`

###### Example

An example `dots`-managed customize directory with scripts:

[alphabetum/dotfiles/script/customize
](https://github.com/alphabetum/dotfiles/tree/master/script/customize)

#### .gitignore

`.gitignore` is particularly useful for excluding sensitive information
from directories in the repository. For example, by default, `dots`
excludes everything in any added `.ssh` directory except for the
`.ssh/config`.

It's also useful for dot directories that have both config files and
large temp or cache files. For example, a `.rbenv` directory for the
[rbenv](https://github.com/sstephenson/rbenv) tool contains both
configuration files and entire Ruby installations that are many
gigabytes in size. You can use `.gitignore` to exclude the ruby
installation directories while tracking the configuration files.

#### Git Commands

`dots` has several commands to make it easier to perform git operations
on the `$DOTFILES` repository. Among these are:

- `dots pull`
- `dots push`
- `dots update_submodules`
- `dots git`

Use the help command (`dots help <command-name>`) to learn more about
these.

#### Other Commands

`dots` includes several other commands for performing operations on
files and inspecting the current state of the repository. All commands
can be viewed by running:

    dots commands

To view the help and usage information for any command, use:

    dots help <command-name>

## More Resources

- [alphabetum/dotfiles](https://github.com/alphabetum/dotfiles)
- [alphabetum/dotfile-research](https://github.com/alphabetum/dotfile-research)

