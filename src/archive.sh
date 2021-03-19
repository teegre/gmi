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
# ARCHIVE
# C : 2021/03/13
# M : 2021/03/19
# D : Article archiving.

source /usr/lib/gmi/core.sh
source /usr/lib/gmi/files.sh

archive() {
  # archive an article

  # src: YYYY/MM/DD/ID/
  # dst: archive/YYYY/MM/DD/ID/

  [[ $src ]] || return 1

  local asrc entry dir title a_index regex
  entry="$1"
  title="$(get_title "$entry")"
  dir="${entry%/*}"
  asrc="$src"
  asrc+="archive/"
  a_index="${asrc}index.gmi" # archive main index.gmi

  regex="^([0-9]{4})/([0-9]{2})/([0-9]{2})/([0-9]+)/index\.gmi$"

  [[ ${entry/$src} =~ $regex ]] && {
    local yy mm dd id
    local path relpath y_index
    yy="${BASH_REMATCH[1]}"
    mm="${BASH_REMATCH[2]}"
    dd="${BASH_REMATCH[3]}"
    id="${BASH_REMATCH[4]}"
    path="${asrc}$yy/$mm/$dd/$id/" # destination path
    relpath="$mm/$dd/$id/"         # relative path
    y_index="${asrc}$yy/index.gmi" # yearly index.gmi

    __err M "archive: $dir"

    [[ -d "$path" ]] || mkdir -p "$path"

    __err M "archive: copy ${entry} => ${path%$id/}"
    cp -nr "${dir:?}"/ "${path%$id/}" &> /dev/null || {
      __err E "archive: error while copying article."
      return 1
    }

   __err M "archive: delete ${entry/index.gmi}"
   delete "$entry" || return 1

    [[ -d "${asrc}$yy" ]] || {
      [[ -a "$a_index" ]] || {
        echo -e "# Archive\n" > "$a_index"
      }
    }
    [[ $(sed -rn "/^=> .+\[$yy\]$/p" "$a_index") ]] ||
      echo "=> ${yy}/index.gmi [$yy]" >> "$a_index"

    [[ -a "$y_index" ]] || {
      local ytitle
      ytitle="$(read_param "yearly_archive_title")" || unset ytitle
      ytitle="${ytitle:-"%y Archive"}"
      ytitle="${ytitle/\%y/$yy}"
      echo -e "# $ytitle\n" > "$y_index"
    }

    echo "=> ${relpath}index.gmi $yy/$mm/$dd $title" >> "$y_index"

    __err M "$name archived."

    return 0
  }
  __err E "archive: could not proceed."
  return 1
}

auto_archive() {
  # automatic archiving.

  [[ $src ]] || return 1

  local y f path
  y="$(_date "%Y")"
  while read -r f; do
    [[ $f =~ ^${src}([0-9]{4}).+$ ]] && {
      [[ ${BASH_REMATCH[1]} -eq "$y" ]] && continue
      archive "$f"
    }
  done < <(find "$src" -regex "${src}[0-9]+/[0-9]+/[0-9]+/[0-9]+\.gmi" | sort)
}
