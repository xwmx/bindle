#!/usr/bin/env bash
#
# DOTFILES
#
# Tasks for managing dotfiles.

###############################################################################
# Tasks
###############################################################################

source_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../home/" && pwd )
target_dir=$HOME

# Maintenance
#------------------------------------------------------------------------------

update-submodules() {
  git submodule foreach git pull
}

update-homebrew() {
  echo ">> Updating Homebrew formulas and casks..."
  $DOTFILES/script/packages/brew.sh
}

update-npm() {
  echo ">> Updating global npm modules..."
  $DOTFILES/script/packages/npm.sh
}

update-pip() {
  echo ">> Updating pip packages..."
  $DOTFILES/script/packages/pip.sh
}

update-packages() {
  update-homebrew
  update-npm
  update-pip
}

customize-icons() {
  echo ">> Customizing icons of Homebrew-installed applications..."
  $DOTFILES/script/customizations/customize_icons.rb
}

configure-osx() {
  echo ">> Configuring OS X preferences..."
  $DOTFILES/script/config/osx.sh
}

configure-osx-apps() {
  echo ">> Configuring OS X application preferences..."
  $DOTFILES/script/config/osx_apps.sh
}

# Linking
#------------------------------------------------------------------------------

# Example task group:
#
# _help-example - prints help text.
# _example() - task to be run for each file.
# example() - the task as it appears to the user
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
#   _each_file _example
# }

# Utility function for iterating over each source file.
_each_dotfile() {
  for f in $source_dir/.*
  do
    filename=$(basename "$f")
    target_file=$target_dir/$filename
    if !( [[ "$filename" =~ ^\.?\.$ ]] ); then
      $1 $f $filename $target_file
    fi
  done
}

# Status

_help-status() {
  echo "Usage: dotfiles status"
  echo ""
  echo "List dotfile status (i = identical, e = a file exists, x = no file eixsts)."
  echo "'@' suffixes denote existing symlinks."
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

# Clean

_help-clean() {
  echo "Usage: dotfiles clean"
  echo ""
  echo "Remove dotfile links in home directory with status 'i'"
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
  echo "Usage: dotfiles clear"
  echo ""
  echo "Remove dotfiles from home directory with status 'i' (via clean task), backs up files with status 'e'"
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
  echo "Usage: dotfiles link"
  echo ""
  echo "Link dotfiles to home directory. Existing files skipped."
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

help() {
  if [[ $# = 0 ]]; then
    echo "Usage: dotfiles [task]"
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

tasks() {
  task_list=($(declare -F))
  for t in ${task_list[@]}
  do
    if !( [[ $t == "declare" ]] || \
          [[ $t == "-f" ]] || \
          [[ "$t" =~ ^_(.*) ]]
    ); then
      echo "$t"
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

