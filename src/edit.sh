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
# EDIT
# C: 2021/03/13
# M: 2021/03/13
# D: Utilities for editing.

source /usr/lib/gmi/core.sh
source /usr/lib/gmi/files.sh

edit() {
  # open an article for editing.
  # if title is changed, link to the article in main index.gmi
  # is also changed.

  local entry
  entry="$1"

  [[ -a "$entry" ]] && {
    local title1 title2
    title1="$(get_title "$entry")"
    exec_editor "$entry" || return 1
    title2="$(get_title "$entry")"
    [[ $title2 != "$title1" ]] &&
      retitle "$entry" "$title2" || return 1
    return 0
  }
  __err E "$entry: no such file."
}

edit_index() {
  # edit main index.gmi files

  [[ $src ]] || return 1
  
  case $1 in
    index  ) exec_editor "${src}index.gmi" ;;
    micro  ) exec_editor "${src}micro.gmi" ;;
    archive) exec_editor "${src}archive/index.gmi" ;;
    *      ) return 1
  esac
}
