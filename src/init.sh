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
# INIT
# C: 2021/03/13
# M: 2021/03/19
# D: Create initial capsule directory structure and files.

source /usr/lib/gmi/core.sh

init() {
  [[ -a "$CONFIG" ]] || {
    __err E "configuration file is missing."
    return 1
  }

  [[ $src ]] || exit 1
  [[ $bak ]] || exit 1

  __err M "init: found source '$src'"
  __err M "init: found backup '$bak'"

  [[ -d "$bak" ]] || mkdir -p "$bak"

  [[ -d "$src" ]] || {
    local a_delimiter
    a_delimiter="$(read_param "article_section_delimiter")" ||
      a_delimiter="---"
    __err M "init: creating directories..."
    [[  -d "${src}archive" ]] ||
      mkdir -p "${src}archive"
    __err M "init: creating files..."
    touch "${src}index.gmi" && {
      {
        echo -e "# Gemini Capsule\n"
        echo -e "=> feed/rss.xml RSS\n"
        echo -e "=> micro.gmi Microblog\n"
        echo -e "=> archive/index.gmi Archive\n"
        echo -e "# Articles\n"
        echo -e "$a_delimiter\n"
      } >> "${src}index.gmi"
      __err M "init: index.gmi [ok]"
    }
    touch "${src}archive/index.gmi" && {
      echo -e "# Archive\n" > "${src}archive/index.gmi"
      __err M "init: archive/index.gmi [ok]"
    }
    touch "${src}micro.gmi" && {
      echo -e "# Microblog\n" > "${src}micro.gmi"
      __err M "init: micro.gmi [ok]"
    }
    touch "${src}favicon.txt"
    __err M "init: done."
    return 0
  }

  __err M "init: nothing to do."
}
