
     _____  ___  _____  _____  ____   _____
    /  _  \/___\/  _  \|  _  \/  _/  /   __\
    |  _  <|   ||  |  ||  |  ||  |---|   __|
    \_____/\___/\__|__/|_____/\_____/\_____/

# bindle

`bindle` is a configuration and dotfile management tool for your personal
unix-like computer.

## Goals & Philosophy

`bindle` provides an easy way to manage a user's configuration, particularly:

- dotfiles,
- user binaries and scripts (ie, anything in `$HOME/bin`),
- scripts for configuration and bootstrapping.

`bindle` is intended to compliment rather than entirely relace manual
configuration and versioning. `bindle` is designed around a logical repository
directory structure that works great with or without the `bindle` program.

See [xwmx/dotfiles](https://github.com/xwmx/dotfiles) for an
example of a configuration managed with `bindle`.

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew install xwmx/taps/bindle
```

### npm

To install with [npm](https://www.npmjs.com/package/bindle-cli):

```bash
npm install --global bindle-cli
```

### bpkg

To install with [bpkg](http://www.bpkg.io/):

```bash
bpkg install xwmx/bindle
```

### Manual

To install manually, simply add the `bindle` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

```bash
curl -L https://raw.github.com/xwmx/bindle/master/bindle \
  -o ~/bin/bindle && chmod +x ~/bin/bindle
```

## Usage

### Help Information

You can view the usage and help information by running `bindle` with no
arguments or with the `--help` or `-h` options.

### Setup

If you don't currently have a local repository tracking your dotfiles,
you can create one using

```bash
bindle init
```

This will initialize a git repository at `$HOME/.bindle` with the following
structure:

    ~/.bindle
    ├── .gitignore
    ├── home/
    ├── bin/
    ├── local/
    └── scripts/
        ├── bootstrap/
        ├── configure/
        ├── customize/
        └── install/

You can change the location used for storing dotfiles by adding a
`.bindlerc` file at `$HOME/.bindlerc` and setting the `$BINDLEPATH` variable to
the desired location:

```bash
export BINDLEPATH="/a/custom/path"
```

### Overview

#### home

Contains all dotfiles and directories from `$HOME` that have been added to the
repository.

The `bindle` command assumes that any items at the root level of this directory
are 1) dotfiles (files and directories with a `.` prefix like `.bashrc` or
`.vim`) and 2) normally exist at your `$HOME` path, aka `~/`, which is the
top level of your user account's home directory.

To list existing dotfiles in `$HOME`, use `bindle list`

```bash
bindle list
```

To track items from `$HOME`, use `bindle track`:

```bash
bindle track .bashrc
```

This adds the file or directory to `BINDLEPATH/home` and creates a symbolic link
in `$HOME` referencing the file or directory.

Once you've added a file, you need to commit it to the repository.

```bash
bindle commit
```

This will `git add` the changed files and do a `git commit`. See `bindle
help commit` for more information.

To list all tracked files:

```bash
bindle list tracked
```

If you want to stop tracking a dotfile or directory, run `bindle untrack`:

```bash
bindle untrack .bashrc
```

This removes the symbolic link in `$HOME` and copies the original file back to
`$HOME` from `$BINDLEPATH/home`.

###### Example

An example `bindle`-managed home directory:

[xwmx/dotfiles/home](https://github.com/xwmx/dotfiles/tree/master/home)

#### bin

`bin` is intended as a directory for executables and scripts that you'd like to
track along with your dotfiles. To make the executables in this directory
accessible to your shell environment, include the following line in your
`.bashrc` or equivalent:

```bash
PATH="${BINDLEPATH}/bin:${PATH}"
```

###### Example

An example `bindle`-managed bin directory:

[xwmx/dotfiles/bin](https://github.com/xwmx/dotfiles/tree/master/bin)

#### local

This directory is excluded from the git repository, and therefore can be
used for storing things related to the configuration that you don't want
to track and don't want in the default directories.

#### scripts

`scripts` contains several subdirectories for contriguration scripts.
Scripts or programs in these directories can be written in any language.
`bindle` makes no assumptions about any of the scripts in these directories
and will simply run them.

To run a script that is located at `$BINDLEPATH/scripts/example.bash`:

```bash
bindle run example.bash
```

Scripts can be organized in subdirectories. Newly-created `bindle`
projects contain several placeholder directories: `bootstrap`,
`configure`, `customize`, `install`.

To run a script that is located at `$BINDLEPATH/scripts/install/example.bash`:

```bash
bindle run install/example.sh
```

For more information, see `bindle help run`

###### Example

An example `bindle`-managed scripts directory:

[xwmx/dotfiles/script
](https://github.com/xwmx/dotfiles/tree/master/script)

##### scripts/bootstrap

Scripts that bootstrap the user account and user-controlled parts of the
system.

For example, bootstrap scripts could set up some default folders and/or call a
series of `install`, `configure`, and `customize` scripts. Generally, a
bootstrap script would only be called once, during an initial setup.

##### scripts/install

Scripts that install programs, such as with package management systems.

For example, you could have a bash script that contains commands for installing
programs via a system-wide package manager like [homebrew](http://brew.sh/) or
a language-specific one like [LuaRocks](http://luarocks.org/).

##### scripts/configure

Scripts that run perform system configuration operations, like setting
preferences.

##### scripts/customize

Scripts that customize any aspect of the configuration or system.

#### .gitignore

`.gitignore` can be used to exclude sensitive information
from directories in the repository. When generating a new repository, `bindle`
excludes everything in any added `.ssh` directory except for the
`.ssh/config`.

`.gitignore` is also useful for dot directories that have both config files
and large temp or cache files. For example, a `.rbenv` directory for the
[rbenv](https://github.com/sstephenson/rbenv) tool contains both
configuration files and entire Ruby installations that are many
gigabytes in size. You can use `.gitignore` to exclude the ruby
installation directories while tracking the configuration files.

### Git Commands

To view the help and usage information for any command, use:

    bindle help <command-name>

#### `add`

```text
Usage:
  bindle add <filename> [--force]

Description:
  `add` is an alias for `track`. For more information, run:
    `bindle help track`
```

#### `commands`

```text
Usage:
  bindle commands [--raw]

Options:
  --raw  Display the command list without formatting.

Description:
  Display the list of available commands.
```

#### `commit`

```text
Usage:
  bindle commit [<message>]

Description:
  Commit the current changes to git. If a message is provided, it will be used
  as the commit message. Otherwise, git will open your default editor.
```

#### `dir`

```text
Usage:
  bindle dir

Description:
  Print the current value of $BINDLEPATH
```

#### `dotfiles`

```text
Usage:
  bindle dotfiles

Description:
  List all dotfiles. Alias for `bindle status`.
```

#### `edit`

```text
Usage:
  bindle edit
  bindle edit [<filename>]

Description:
  Open a tracked file or, when no filename is specified, the entire tracked
  repository in you $EDITOR, currently set to 'vim'.
```

#### `git`

```text
Usage:
  bindle git command [--options] [<arguments>]

Description:
  Run a git command within the $BINDLEPATH directory.
```

#### `help`

```text
sage:
  bindle help [<command>]

Description:
  Display help information for bindle or a specified command.
```

#### `init`

```text
Usage:
  bindle init [<source_repository>] [<bindlepath>] [--initialize-submodules] [--skip-bindlerc]

Options:
  --initialize-submodules  Initialize repository submodules when used with a
                           source_repository argument.
  --skip-bindlerc          Don't generate a bindlerc file.

Description:
  Create initial repository file structure.

  When provided with a URL as the first argument or a second argument the git
  repository at that URL is cloned and used as the tracking repository.

  When provided with an absolute path as the lone argument or second argument
  after a repository URL, the initial repository is created at the specified
  path and a configuration file is created at $HOME/.bindlerc with that
  location set as the $BINDLEPATH.
```

#### `link`

```text
Usage:
  bindle link [<filename>] [--overwrite [--with-backup]]

Options:
  --overwrite    Overwrite any files that exist in the directory where links
                 are being created, meaning that any conflicting files will be
                 deleted and links to the corresponding repository file will
                 be created.
  --with-backup  When used in combination with --overwrite, any overwritten
                 files are first renamed with a '.bak' extension. If a file
                 with the same name plus '.bak' extension already exists,
                 nothing is done to this file and no link is created.

Description:
  Create a link in $HOME that references the corresponding item in the
  tracked directory.

  By default, the command links all files that exist in the tracked directory.
  If a filename is passed to the link command, then it only acts on that file.
```

#### `list`

```text
Usage:
  bindle list [tracked | untracked] [<search string>]

Description:
  List all files in $HOME.

  If 'tracked' or 'untracked' as passed as arguments to 'list', then only the
  files with those statuses are listed. When provided with a seach string, all
  matching filenames will be printed.
```

#### `pull`

```text
Usage:
  bindle pull

Description:
  Pull latest changes from the remote repository.
```

#### `push`

```text
Usage:
  bindle push

Description:
  Push local commits to the remote repository.
```

#### `rename`

```text
Usage:
  bindle rename <old_filename> <new_filename>

Decription:
  Rename a tracked file and its corresponding link in $HOME.
```

#### `restore`

```text
Usage:
  bindle restore <filename>

Description:
  `restore` is an alias for `untrack`. For more information, run:
    `bindle help untrack`
```

#### `run`

```text
Usage:
  bindle run ( list | <script_name> )

Description:
  Run and list scripts.

  Scripts can be added to:
    $BINDLEPATH/scripts/
```

#### `scripts`

```text
Usage:
  bindle scripts

Description:
  List all scripts. Alias for `bindle run`.
```

#### `status`

```text
Usage:
  bindle status

Description:
  List status of files in $HOME with filenames matching those in
  $BINDLEPATH/home/.

  Indicators display information about the status of each entry:
   ✅   - Identical, indicating a valid symbolic link to the tracked file
     e  - A file exists, but it's not linked to tracked file
      x - No file exists
```

#### `submodules`

```text
Usage:
  bindle submodules ( sync | update )

Subcommands:
  sync    Sync all submodules with the current head commit. This usually be
          should be performed after a `bindle pull`. Equivalent git command:
            git submodule update --recursive --init
  update  Update all first-level submodules to the latest commit in each
          submodule's origin repository. Equivalent git command:
            git submodule update --init --remote
```

#### `sync`

```text
Usage:
  bindle sync

Description:
  Pull latest changes from the remote repository and sync submodules.
```

#### `track`

```text
Usage:
  bindle track <filename> [--force]

Options:
  --force  Overwrite files and folders in the repository that have the same
           name as the item(s) being added.

Description:
  Track the specified file, adding it to the repository and adding a link in
  $HOME to the tracked file.
```

#### `tracked`

```text
Usage:
  bindle tracked

Description:
  List all tracked dotfiles in $HOME.
```

#### `unlink`

```text
Usage:
  bindle unlink [<filename>]

Description:
  Remove symlinks in $HOME.

  By default, the command removes all of the symlinks pointing to items in
  tracked directory. If a filename is passed to the unlink command, then it
  only acts on symlinks to that file.
```

#### `untrack`

```text
Usage:
  bindle untrack <filename>

Description:
  Unlink the specified file and move it from the tracked location in the
  repository back to original location in $HOME.
```

#### `untracked`

```text
Usage:
  bindle untracked

Description:
  List all untracked dotfiles in $HOME.
```

#### `version`

```text
Usage:
  bindle ( version | --version )

Description:
  Display the current program version.
```

## More Resources

- [xwmx/dotfiles](https://github.com/xwmx/dotfiles)
- [xwmx/dotfile-research](https://github.com/xwmx/dotfile-research)
