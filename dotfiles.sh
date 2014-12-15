#!/usr/bin/env bash
#
# DOTFILES
#
# Tasks for managing dotfiles.

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


help() {
  if [[ $# = 0 ]]; then
    echo "Usage: dotfiles [task]"
  else
    echo $(help-$1)
  fi
}

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

