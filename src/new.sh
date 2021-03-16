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
# NEW
# C: 2021/03/13
# M: 2021/03/16

source /usr/lib/gmi/core.sh

insert_entry() {
  # insert article link in main index.gmi file.

  local delim 
  delim="$(read_param "articles_section_delimiter")" ||
    delim="---"

  sed -i '/'"$delim"'/ i '"$1"'' "${src}index.gmi"
}

new() {
  # create a new article and
  # add it to index.gmi.

  [[ $src ]] || return 1
  
  local tmpfile title date_format entry_date
  tmpfile="$(mktemp)"
  title="${1:-"Untitled"}"
  
  date_format="$(read_param "date_format_articles")" ||
    date_format="%F"
  
  entry_date="$(_date "$date_format")"
  
  echo "# $title" > "$tmpfile"
  echo -e "\n$entry_date" >> "$tmpfile"
  
  local time1 time2
  time1="$(stat -c "%Y" "$tmpfile")"
  exec_editor "$tmpfile"
  time2="$(stat -c "%Y" "$tmpfile")"
  
  [[ $time1 == "$time2" ]] && {
    rm "$tmpfile"
    __err W "no change."
    return 1
  }

  title="$(get_title "$tmpfile")"

  local dd mm yy index entry
  dd="$(_date "%d")"
  mm="$(_date "%m")"
  yy="$(_date "%Y")"
  path="$yy/$mm/$dd/"
  index=1
  while [[ -d "${src}${path}$index" ]]; do ((index++)); done
  path+="$index/"
  [[ -d "${src}$path" ]] || mkdir -p "${src}$path"
  entry="${src}${path}index.gmi"
  mv "$tmpfile" "$entry"
  __err M "saved entry: ${entry}."
  insert_entry "=> ${path}index.gmi $yy/$mm/$dd $title"
}
