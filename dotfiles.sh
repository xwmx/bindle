#!/usr/bin/env bash
#
# DOTFILES
#
# Tasks for managing dotfiles.
#
# Example task group:
#
# _help-example - Optional. Prints help text.
# _example() - Optional. The task to be run for each dotfile.
# example() - The task as it appears to the user
#
#
# _help-example() {
#   echo "Example help text."
# }
# _example() {
#   echo $f
#   echo $filename
#   echo $target_file
# }
# example() {
#   _each_dotfile _example
# }


###############################################################################
# Environment
###############################################################################

_me=$(basename $0)
source_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../home/" && pwd )
target_dir=$HOME

###############################################################################
# Utility functions
###############################################################################

# Iterate over each dotfile and execute a provided function on each one.
_each_dotfile() {
  per_file_command=$1
  for f in $source_dir/.*
  do
    filename=$(basename "$f")
    target_file=$target_dir/$filename
    if !( [[ "$filename" =~ ^\.?\.$ ]] ); then
      # Subfunctions can access the variables in this command, so it's not
      # necessary to pass them as arguments.
      $per_file_command
    fi
  done
}

###############################################################################
# Tasks
###############################################################################

source_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../home/" && pwd )
target_dir=$HOME

# Maintenance
#------------------------------------------------------------------------------

_help-update-submodules() {
cat <<EOM
Usage: $_me update-submodules

Update git submodules. An alias for the git command:
  git submodule foreach git pull
EOM
}
update-submodules() {
  git submodule foreach git pull
}

_help-update-homebrew() {
cat <<EOM
Usage: $_me update-homebrew

Update homebrew and homebrew cask using the brew.sh install script.

brew.sh location:
  $DOTFILES/script/packages/brew.sh

EOM
}
update-homebrew() {
  echo ">> Updating Homebrew formulas and casks..."
  $DOTFILES/script/packages/brew.sh
}

_help-update-npm() {
cat <<EOM
Usage: $_me update-npm

Update node modules using the npm.sh script.

npm.sh location:
  $DOTFILES/script/packages/npm.sh

EOM
}
update-npm() {
  echo ">> Updating global npm modules..."
  $DOTFILES/script/packages/npm.sh
}

_help-update-pip() {
cat <<EOM
Usage: $_me update-pip

Update Python pip packaages using the pip.sh script.

pip.sh location:
  $DOTFILES/script/packages/pip.sh

EOM
}
update-pip() {
  echo ">> Updating pip packages..."
  $DOTFILES/script/packages/pip.sh
}

_help-update-packages() {
cat <<EOM
Usage: $_me update-packages

Update Homebrew, Homebrew Cask, npm, and pip using each dedicated task:
  update-homebrew
  update-npm
  update-pip

For information about each task, see help for the individual tasks.
EOM
}
update-packages() {
  update-homebrew
  update-npm
  update-pip
}

_help-customize-icons() {
cat <<EOM
Usage: $_me customize-icons

Customize icons of Homebrew-installed applications.

For more information, reference the following script:
  $DOTFILES/script/customizations/customize_icons.rb
EOM
}
customize-icons() {
  echo ">> Customizing icons of Homebrew-installed applications..."
  $DOTFILES/script/customizations/customize_icons.rb
}

_help-configure-osx() {
cat <<EOM
Usage: $_me configure-osx

Set various preferences for OS X and default Apple applications.

For more information, reference the following script:
  $DOTFILES/script/config/osx.sh
EOM
}
configure-osx() {
  echo ">> Configuring OS X preferences..."
  $DOTFILES/script/config/osx.sh
}

_help-configure-osx-apps() {
cat <<EOM
Usage: $_me configure-osx

Set various preferences for non-default OS X applications.

For more information, reference the following script:
  $DOTFILES/script/config/osx_apps.sh
EOM
}
configure-osx-apps() {
  echo ">> Configuring OS X application preferences..."
  $DOTFILES/script/config/osx_apps.sh
}

# Linking
#------------------------------------------------------------------------------

# Status

_help-status() {
cat <<EOM
Usage: $_me status

List dotfile status (i = identical, e = a file exists, x = no file eixsts).
'@' suffixes denote existing symlinks.
EOM
}
_status() {
  if ( [[ -L $target_file ]] && \
       [[ "$(readlink $target_file)" == "$f" ]]
  ); then
    echo "i   $filename"
  elif [[ -a $target_file ]]; then
    echo " e  $filename"
  else
    echo "  x $filename"
  fi
}
status() {
  _each_dotfile _status
}

# Backup Status

_help-backup-status() {
cat <<EOM
Usage: $_me backup-status

List dotfile backup (.bak file) status (i = identical, e = a file exists, x = no file eixsts).
'@' suffixes denote existing symlinks.
EOM
}
_backup-status() {
  target_file=$target_file.bak
  if ( [[ -L $target_file ]] && \
       [[ "$(readlink $target_file)" == "$f" ]]
  ); then
    echo "i   $filename.bak"
  elif [[ -a $target_file ]]; then
    echo " e  $filename.bak"
  else
    echo "  x $filename.bak"
  fi
}
backup-status() {
  _each_dotfile _backup-status
}

# Clean

_help-clean() {
cat <<EOM
Usage: $_me clean

Remove dotfile links in home directory with status 'i'
EOM
}
_clean() {
  if ( [[ -L $target_file ]] && \
       [[ "$(readlink $target_file)" == "$f" ]]
  ); then
    echo "Removing linked file: $target_file"
    rm $target_file
  fi
}
clean() {
  _each_dotfile _clean
}

# Clear

_help-clear() {
cat <<EOM
Usage: $_me clear

Remove $_me from home directory with status 'i' (via clean task), backs up files with status 'e'
EOM
}
_clear() {
  if [[ -a $target_file ]]; then
    echo "Backing up file: $target_file"
    mv $target_file "$target_file".bak
  fi
}
clear() {
  clean
  _each_dotfile _clear
}

# Link

_help-link() {
cat <<EOM
Usage: $_me link

Link dotfiles to home directory. Existing files skipped.
EOM
}
_link() {
  if [[ -a $target_file ]]; then
    echo Exists: $filename
  else
    echo "Linking $f => $target_file"
    ln -s $f $target_file
  fi
}
link() {
  _each_dotfile _link
}

# Help
#------------------------------------------------------------------------------

_function_exists() {
  [ `type -t $1`"" == 'function' ]
}


_help-help() {
cat <<EOM
Usage: $_me help [task]

Display help information for the dotfiles command or a specified task.
EOM
}
help() {
  if [[ $# = 0 ]]; then
    cat <<EOM

      _       _    __ _ _
     | |     | |  / _(_) |
   __| | ___ | |_| |_ _| | ___  ___
  / _\` |/ _ \\| __|  _| | |/ _ \\/ __|
 | (_| | (_) | |_| | | | |  __/\\__ \\
  \\__,_|\\___/ \\__|_| |_|_|\\___||___/

Tasks for managing OS X dotfiles and environment config.

Usage:
  $_me [task]

Task help:
  $_me help [task]

$(tasks --pretty)
EOM
 else
   local help_function="_help-$1"
   if _function_exists $help_function ; then
     echo "$($help_function)"
   else
    echo "No additional information for $1"
   fi
 fi
}

# Task Listing
#------------------------------------------------------------------------------

_help-tasks() {
cat <<EOM
Usage: $_me tasks [--pretty]

Display the list of available tasks.
EOM
}
tasks() {
  [[ $1 == "--pretty" ]] && echo "Available tasks:"
  task_list=($(declare -F))
  for t in ${task_list[@]}
  do
    if !( [[ $t == "declare" ]] || \
          [[ $t == "-f" ]] || \
          [[ "$t" =~ ^_(.*) ]]
    ); then
      if [[ $1 == "--pretty" ]]; then
        echo "  $t"
      else
        echo "$t"
      fi
    fi
  done
}

###############################################################################
# Main
###############################################################################

_dotfiles_main() {
  if ( [[ $# = 0 ]] || [[ $1 == "-h" ]] ); then
    help
  else
    eval $@
    exit 0
  fi
}

# dotfiles main function
_dotfiles_main $@

