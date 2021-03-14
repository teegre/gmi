#! /usr/bin/env bash

# 
#                  _
#   __ _ _ __ ___ (_)
#  / _` | '_ ` _ \| | gemini
# | (_| | | | | | | | capsule
#  \__, |_| |_| |_|_| generator
#  |___/
#
# FILES
# C: 2021/03/13
# M: 2021/03/13
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
  
  index="${src}index.gmi"
  rm "$dir"/* 2> /dev/null || {
    __err E "$dir/*: no such file or directory."
    return 1
  }
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
