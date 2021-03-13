#! /usr/bin/env bash

#
#                  _
#   __ _ _ __ ___ (_)
#  / _` | '_ ` _ \| | gemini
# | (_| | | | | | | | capsule
#  \__, |_| |_| |_|_| generator
#  |___/
#
# LIST
# C: 2021/03/13
# M: 2021/03/13
# D: Display a list menu.

source core.sh

list() {
  # list options and articles.

  [[ $src ]] || return 1

  local entry

  entry="$(
  (
      echo "new"
      echo "post"
      echo "deploy"
      find "$src" -not \( -path "${src}"archive -prune \) -regex '^.+/[0-9]+.+/index\.gmi$' | sort
      echo "index"
      echo "micro"
      echo "archive index"
      echo "archived"
      echo "auto archive"
      echo "quit"
  ) | fzf +s --tac --header "gmi version $__version")"
  echo "$entry"
}

list_archived() {
  # list archived articles

  [[ $src ]] || return 1

  entry="$(
  (
      find "${src}archive/" -regex '[0-9]+.+index\.gmi$' | sort
      echo "quit"
  ) | fzf +s --tac --header "gmi version $__version")"
  echo "$entry"
}
