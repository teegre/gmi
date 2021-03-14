#! /usr/bin/env bash

#
#                  _
#   __ _ _ __ ___ (_)
#  / _` | '_ ` _ \| | gemini
# | (_| | | | | | | | capsule
#  \__, |_| |_| |_|_| generator
#  |___/
#
# DEPLOY
# C: 2021/03/13
# M: 2021/03/13
# D: For deploying a capsule on the server.

source core.sh
source rss.sh

deploy() {
  # deploy capsule on server.

  [[ $src ]] || return 1

  local dst ssh_cmd ssh_id_file ssh_port
  dst="$(read_param "server_destination_dir")" || {
    __err E "config: missing destination directory."
    return 1
  }

  [[ $dst =~ .*/$ ]] || dst+="/"
  
  ssh_port="$(read_param "ssh_port")" ||
    unset ssh_port

  ssh_id_file="$(read_param "ssh_identity_file")" ||
    unset ssh_id_file

  ssh_cmd="ssh"
  [[ $ssh_port ]] && ssh_cmd+=" -p $ssh_port"
  [[ $ssh_id_file ]] && ssh_cmd+=" -i $ssh_id_file"

  [[ $1 ]] || {
    rss
    __err M "$src -> $dst"
    rsync -hruv --delete -e "$ssh_cmd" --rsync-path="sudo rsync" "$src" "$dst" || {
      __err E "micro: an error occured."
      return 1
    }
    __err M "deployed."
  }

  [[ $1 == "micro" ]]  && {
    __err M "micro: posting microblog entry."
    rsync -hruv --delete -e "$ssh_cmd" --rsync-path="sudo rsync" "${src}micro.gmi" "$dst" || {
      __err E "micro: an error occured."
      return 1
    }
    __err M "micro: posted."
  }
}