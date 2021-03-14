#! /usr/bin/env bash

#
#                  _
#   __ _ _ __ ___ (_)
#  / _` | '_ ` _ \| | gemini
# | (_| | | | | | | | capsule
#  \__, |_| |_| |_|_| generator
#  |___/
# 
# NEW
#

source /usr/lib/gmi/core.sh

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
  echo "=> ${path}index.gmi $yy/$mm/$dd $title" >> "${src}index.gmi"
}
