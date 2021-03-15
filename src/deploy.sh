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
# DEPLOY
# C: 2021/03/13
# M: 2021/03/15
# D: For deploying a capsule on the server.

source /usr/lib/gmi/core.sh
source /usr/lib/gmi/rss.sh

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
    rsync -a -e "$ssh_cmd" --rsync-path="sudo rsync" "${src}micro.gmi" "$dst" || {
      __err E "micro: an error occured."
      return 1
    }
    __err M "micro: posted."
  }
}
