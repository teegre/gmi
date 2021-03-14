#! /usr/bin/env bash

#                  _
#   __ _ _ __ ___ (_)
#  / _` | '_ ` _ \| | gemini
# | (_| | | | | | | | capsule
#  \__, |_| |_| |_|_| generator
#  |___/
#
# MICRO
# C : 2021/03/13
# M : 2021/03/13
# D : Microblogging utility.

source /usr/lib/gmi/core.sh
source /usr/lib/gmi/deploy.sh

post() {
  # add a microblog entry.
  
  [[ $src ]] || return 1

  [[ $1 ]] || {
    local tmp time1 time2
    tmp="$(mktemp)"
    time1="$(stat -c "%Y" "$tmp")"
    exec_editor "$tmp"
    time2="$(stat -c "%Y" "$tmp")"
    [[ $time2 == "$time1" ]] && {
      rm "$tmp"
      __err W "cancelled."
      return 1
    }
  }

  local date_format now msg
  date_format="$(read_param "date_format_micro")" ||
    date_format="%F %T"
  now="$(_date "$date_format")"
  msg="${1:-"$(<"$tmp")"}"
  echo -e "## $now\n$msg\n" >> "${src}micro.gmi"
  [[ -a "$tmp" ]] && rm "$tmp"
  deploy micro
}
