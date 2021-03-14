#! /usr/bin/env bash

#
#                  _
#   __ _ _ __ ___ (_)
#  / _` | '_ ` _ \| | gemini
# | (_| | | | | | | | capsule
#  \__, |_| |_| |_|_| generator
#  |___/
#
# INIT
# C: 2021/03/13
# M: 2021/03/13
# D: Create initial capsule directory structure.

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
    __err M "init: creating directories..."
    [[  -d "${src}archive" ]] ||
      mkdir -p "${src}archive"
    __err M "init: creating files..."
    touch "${src}index.gmi" && {
      {
        echo -e "# Gemini Capsule\n"
        echo -e "Made with Gmi, the Gemini Capsule Generator.\n"
        echo -e "=> feed/rss.xml RSS\n"
        echo -e "=> micro.gmi Microblog\n"
        echo -e "=> archive/index.gmi Archive\n"
        echo -e "# Articles\n"
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
    __err M "init: done."
    return 0
  }

  __err M "init: nothing to do."
}
