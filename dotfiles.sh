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

source_file() {
  echo $source_dir/$1
}

target_file() {
  echo $target_dir/$1
}

source_files() {
  local i=0
  local files=()
  for f in $source_dir/.*
  do
    filename=$(basename "$f")
    if !( [[ "$filename" =~ ^\.?\.$ ]] ); then
      $files[$i]
      ((i++))
    fi
  done
  echo $files[@]
}

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

_help-status() {
  echo "List dotfile.bak status (i = identical, e = a file exists, x = no file eixsts)."
  echo "'@' suffixes denote existing symlinks."
}
status() {
  for f in $source_dir/.*
  do
    filename=$(basename "$f")
    target_file=$target_dir/$filename
    if !( [[ "$filename" =~ ^\.?\.$ ]] ); then
      if ( [[ -L $target_file ]] && \
           [[ "$(readlink $target_file)" == "$f" ]]
      ); then
        echo "i   $filename"
      elif [[ -a $target_file ]]; then
        echo " e  $filename"
      else
        echo "  x $filename"
      fi
    fi
  done
}

_help-clean() {
  echo "Remove dotfile links in home directory with status 'i'"
}
clean() {
  for f in $source_dir/.*
  do
    filename=$(basename "$f")
    target_file=$target_dir/$filename
    if !( [[ "$filename" =~ ^\.?\.$ ]] ); then
      if ( [[ -L $target_file ]] && \
           [[ "$(readlink $target_file)" == "$f" ]]
      ); then
        echo "Removing linked file: $target_file"
        rm $target_file
      fi
    fi
  done
}

_help-clear() {
  echo "Remove dotfiles from home directory with status 'i' (via clean task), backs up files with status 'e'"
}
clear() {

  clean

  for f in $source_dir/.*
  do
    filename=$(basename "$f")
    target_file=$target_dir/$filename
    if !( [[ "$filename" =~ ^\.?\.$ ]] ); then
      if [[ -a $target_file ]]; then
        echo "Backing up file: $target_file"
        mv $target_file "$target_file".bak
      fi
    fi
  done
}

_help-link() {
  echo "Link dotfiles to home directory. List files skipped."
}
link() {
  existing_files=""
  for f in $source_dir/.*
  do
    filename=$(basename "$f")
    target_file=$target_dir/$filename
    if !( [[ "$filename" =~ ^\.?\.$ ]] ); then
      if [[ -a $target_file ]]; then
        echo Exists: $target_file
      else
        echo "Linking $f => $target_file"
        ln -s $f $target_file
      fi
    fi
  done
}



# Help
#------------------------------------------------------------------------------

help() {
  if [[ $# = 0 ]]; then
    echo "Usage: dotfiles [task]"
  else
    echo "$(_help-$1)"
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

