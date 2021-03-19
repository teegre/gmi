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
# BACKUP
# C : 2021/03/18
# M : 2021/03/19
# D : Backup utility.

source /usr/lib/gmi/core.sh

backup() {
  local name
  name="$(_date "%Y%m%d%H%M%S.tar.gz")"

  __err M "processing $name..."
  pushd "$src" &> /dev/null || return 1
  tar -czf "${bak}$name" . &> /dev/null || {
    __err E "something went wrong."
    return 1
  }
  popd &> /dev/null || return 1
  __err M "done."
}

backup_list() {
  local entry
  [[ -a $(find "$bak" -prune -type d -empty) ]] && {
    __err M "no backup found."
    return
  }
  entry="$(
    find "$bak" -name "*.tar.gz" | sort | fzf +s --tac --header "gmi version $__version")"
  [[ $entry  ]] || { __err M "cancelled."; return 0; }
  echo "$entry"
}

restore() {
  local name
  name="$(backup_list)"
  
  [[ $name ]] && {
    __err W "warning: it will overwrite current capsule."
    confirm "continue?" && {
      __err M "processing..."
      rm -r "${src:?}"/*
      tar xzf "$name" -C "$src" && {
        __err M "success!"
        __err M "do you want to delete backup file ${name##*/}"
        confirm "delete?" && rm "$name"
        return 0
      }
      __err E "something went wrong."
    }
  }
}
