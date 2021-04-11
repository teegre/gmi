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
# CORE
# C : 2021/03/13
# M : 2021/04/11
# D : Utility functions

# shellcheck disable=SC2034
__version="0.7.3"

CONFIG="$HOME/.config/gmi/config"

_date() {
  # builtin date function.
  # print the current time in the given format.
  #
  # usage:
  # _date <format>

  printf "%($1)T\\n" "-1"
}

exec_editor() {
  # open file in editor.
  "${EDITOR:-nano}" "$1"
}

__err() {
  # error/message display.
  local _type
  case $1 in
    E) _type="!! "; shift ;; # error
    M) _type=":: "; shift ;; # message
    W) _type="-- "; shift ;; # warning
  esac
  >&2 echo "${_type}$1"
}

read_param() {
  # return value from configuration file.
  local param line regex
  param="$1"
  [[ $param ]] || { echo "null"; return 1; }
  regex="^[[:space:]]*${param%=*}[[:space:]]*=[[:space:]]*(.+)$"
  while read -r line; do
    [[ $line =~ ^#.*$ ]] && continue # ignore comments.
    if [[ $line =~ $regex ]]; then
      if [[ ! ${BASH_REMATCH[1]} ]]; then
        echo "null"
        return 1
      else
        echo "${BASH_REMATCH[1]//\~/$HOME}" # expand ~
        return 0
      fi
    fi
  done < "$CONFIG"
  echo "null"
  return 1
}

get_dir() {
  # return preformatted directory
  # from configuration file.
  local dir value
  case $1 in
    src) dir="source_dir" ;;
    bak) dir="backup_dir" ;;
    *  ) dir="source_dir" ;;
  esac
  value="$(read_param "$dir")" || {
    __err E "config: missing [$dir]."
    return 1
  }
  [[ $value =~ .*/$ ]] || value+="/"
  echo "$value"
}

get_title() {
  # return title of a given article.

  local entry="$1"
  [[ -s "$entry" ]] &&  {
    # shellcheck disable=SC2016
    sed -r 's_^# (.+)$_\1_;1q' "$entry"
    return 0
  }
  return 1
}

get_date() {
  # return creation date (in seconds since the epoch)
  # of a given article.

  [[ $1 ]] || return 1

  local regex f d
  regex="^${src}([0-9]{4}/[0-9]{2}/[0-9]{2})/.+$"

  f="$1"

  [[ $f =~ $regex ]] && {
    d="${BASH_REMATCH[1]}"
    date -d "$d" "+%s"
    return 0
  }
  return 1
}

confirm() {
  # ask user for confirmation.

  local prompt answer
  prompt="${1:-"sure?"}"

  printf ":: %s [y/N]: " "$prompt"
  read -r r
  [[ ${r,,} == "y" ]] && return 0
  return 1
}

src="$(get_dir src)" || unset src
bak="$(get_dir bak)" || unset bak

