         _       _
        | |     | |
      __| | ___ | |_ ___
     / _` |/ _ \| __/ __|
    | (_| | (_) | |_\__ \
     \__,_|\___/ \__|___/

# dots

`dots` is a tool and framework for managing the configuration of individual
\*nix systems, such as an OS X or Ubuntu laptop.

The core goal of `dots` is to provide an easy way to manage dotfiles, per-user
binaries, packages, and configuration scripts using an approach that's easy to
reason about while using as few dependencies as possible. As a result,
the project structure is intended to reflect the original locations of
the files and the commands try to be as close to simple task automation
or the underlying git commands as possible.

See [alphabetum/dotfiles](https://github.com/alphabetum/dotfiles) for an
example of a configuration managed with `dots`.

## Usage

To get started, add the `dots` script to your path.

### Help

You can view the help information by running `dots` with no arguments.

### init

If you don't currently have a local repository tracking your dotfiles,
you can create one using the `dots init` command, which will initialize
a git repository at `$HOME/.dotfiles` with the following structure:


    ├── .gitignore
    ├── home/
    ├── local/
    └── script/
        ├── configure/
        ├── customize/
        └── install/

You can change the location used for storing dotfiles by adding a
`$DOTFILES` variable to your environment set to the desired location:

    export DOTFILES="$HOME/configuration"

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

#### local

This directory is excluded from the git repository, and therefore can be
used for storing things related to the configuration that you don't want
to track and don't want in the default directories.

#### script

`script` contains three subdirectories for contriguration scripts.
Scripts in this directory can be written in any language and can be run
either individually or in aggregate. `dots` makes no assumptions about
any of the scripts in these directories and will simply run them.

##### install

`install` should contain scripts for installing programs, ideally via
package management systems. For example, you could have a bash script
that contains commands for installing programs via a system-wide package
manager like [homebrew](http://brew.sh/) or a language-specific one like
[LuaRocks](http://luarocks.org/).

To run an install script, use a command like:

    dots install gems.sh

For more information, see `dots help install`

##### configure

`configure` is intended for scripts that run perform system
configuration operations, like setting OS X preferences.

To run a configuration script, use something like:

    dots configure osx.sh

##### customize

`customize` is intended for scripts that customize any aspect of the
configuration or anything else on the system. In other words, 'hacks'.
For example, I use it for changing icons on installed applications.

    dots customize app_icons.py


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

Use the help command to view the specifics about each command.

#### Other Commands

`dots` includes several other commands for performing operations on
files and inspecting the current state of the repository. All commands
can be viewed by running `dots commands` and you can use
`dots help command-name` to view the help for each command.
