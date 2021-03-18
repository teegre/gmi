#! /usr/bin/env bash

#                  _
#   __ _ _ __ ___ (_)
#  / _` | '_ ` _ \| | gemini
# | (_| | | | | | | | capsule
#  \__, |_| |_| |_|_| generator
#  |___/
#
# This file is part of gmi.
# Copyright (C) 2021, Stéphane MEYER.
# 
# Gmi is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>
#
# LIST
# C: 2021/03/13
# M: 2021/03/16
# D: Display a list menu.

source /usr/lib/gmi/core.sh

article_list() {
  local entry title article adate
  declare -A alist
  while read -r entry; do
    title="$(get_title "$entry")"
    [[ $entry =~ ^.+/([0-9]{4}/[0-9]{2}/[0-9]{2})/.+$ ]] &&
      adate="${BASH_REMATCH[1]}"
    alist["$adate $title"]="$entry"
  done < <(find "$src" -not \( -path "${src}"archive -prune \) -regex '^.+/[0-9]+.+/index\.gmi$' | sort)
  article="$(
  (
    for entry in "${!alist[@]}"; do
      echo "$entry"
    done
  ) | fzf +s --tac --header "gmi version $__version")"
  [[ $article ]] || { __err M "cancelled."; return 0; }
  echo "${alist["$article"]}"
}

list_archived() {
  # list archived articles

  [[ $src ]] || return 1

  entry="$(
  (
      find "${src}archive/" -regex '^.+/[0-9]+.+/index\.gmi$' | sort
      echo "quit"
  ) | fzf +s --tac --header "gmi version $__version")"

  [[ $entry == "quit" ]] && return

  [[ $entry ]] && {
    source /usr/lib/gmi/edit.sh
    edit "$entry"
  }
}
