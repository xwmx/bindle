         _       _
        | |     | |
      __| | ___ | |_ ___
     / _` |/ _ \| __/ __|
    | (_| | (_) | |_\__ \
     \__,_|\___/ \__|___/

# dots

`dots` is a configuration tool and framework focused on configuring
individual \*nix systems, such as an OS X or Ubuntu laptop.

The core goal of `dots` is to provide an easy way to manage dotfiles,
per-user binaries, and packages, using an approach that's easy to
understand and reason about while using as few dependencies as possible.

The three main functions of `dots` are:

1. track dotfiles in a source controlled respository,
2. track local binaries from the user's `$HOME/bin` directory,
3. provide a simple set of commands for installing packages for various
   package managers.

In order to strike a balance between portability and ease of
development, `dots` is written in bash.


