#! /usr/bin/env bash

# 
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
# FILES
# C: 2021/03/13
# M: 2021/09/02
# D: File utilities.

source /usr/lib/gmi/core.sh

retitle() {
  # rename an article.

  local entry year index newtitle name pdate force
  
  [[ $src ]] || return 1

  [[ $1 == "-f" ]] && { force=1; shift; }

  entry="$1"; shift

  [[ -a "$entry" ]] || {
    __err E "$entry: no such file."
    return 1
  }
  
  [[ $entry =~ ^${src}/archive/([0-9]+)/.+$ ]] && { # archived?
    year="${BASH_REMATCH[1]}"
    src+="archive/"
  }
  index="${src}${year}index.gmi"
  
  newtitle="$1"; shift
  name="${entry/$src}"
  pdate="${name%*/*/*.gmi}"
  
  [[ $force ]] && {
    sed  -i "s_^# .*\$_# ${newtitle}_" "$entry"
    __err M "$name renamed."
  }

  [[ -a "$index" ]] || {
    __err E "${index}: no such file."
    return 1
  }

  sed -i "s_=> ${entry/${src}$year} ${pdate}.*_=> ${entry/${src}$year} $pdate ${newtitle}_" "$index"
  __err M "article $name renamed in $index"
}

retitle_usr() {
  # rename an article via user input.

  local entry name title newtitle
  entry="$1"
  title="$(get_title "$entry")"
  read -i "$title" -p ":: enter new title: " -re newtitle
  [[ $newtitle ]] || return 1
  retitle -f "$entry" "$newtitle"
}

delete() {
  # delete an article and remove its link
  # in corresponding index.gmi file.

  [[ $src ]] || return 1

  local entry name dir title index
  
  entry="$1"
  name="${entry/$src}"
  dir="${entry%/*}"
  title="$(get_title "$entry")"

  [[ -a "$entry" ]] || {
    __err E "${name}: no such file."
    return 1
  }
  
  rm -r "${dir:?}"/* || {
    __err E "delete: something went wrong."
    return 1
  }

  # check if archived!
  if [[ $name =~ ^archive/([0-9]{4})/.*$ ]]; then
    index="${src}archive/${BASH_REMATCH[1]}/index.gmi"
  else
    index="${src}index.gmi"
  fi

  __err M "$name deleted."
  sed -i "/^=> .*${title}.*$/d" "$index"
  __err M "$name removed from $index"
  delete_empty_dir "$dir"
}

delete_empty_dir() {
  # delete empty directories recursively.
  
  [[ $src ]] || return 1

  local dir
  dir="$1"

  [[ -a $(find "$dir" -prune -type d -empty) ]] && {
    __err W "$dir is empty, deleting..."
    rm -rf "$dir" && {
      [[ $dir != "$src" ]] &&
        delete_empty_dir "${dir%/*}"
    }
    return 0
  }
  return 1
}
