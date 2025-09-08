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
# RSS
# C : 2021/03/13
# M : 2021/03/13
# D : Generate RSS feed.

source ${HOME}/.local/lib/gmi/core.sh

rss() {
  # generate rss feed.
  
  [[ $src ]] || return 1

  local header item footer

header=$(cat << 'EOF'
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
<channel>
<title>[TITLE]</title>
<description>
[DESCRIPTION]
</description>
<link>[URL]</link>
<lastBuildDate>[DATE]</lastBuildDate>
EOF
)
item=$(cat << 'EOF'
<item>
<link>[URL]</link>
<pubDate>[DATE]</pubDate>
<title>[ITEMTITLE]</title>
<description>
[ITEMDESCRIPTION]
</description>
</item>
EOF
)
footer=$(cat << 'EOF'
</channel>
</rss>
EOF
)

  __err M "generating rss..."

  local title desc url
  title="$(read_param "rss_title")" || {
    __err E "config: rss_title missing."
    return 1
  }

  desc="$(read_param "rss_description")" || {
    __err E "config: rss_description missing."
    return 1
  }

  url="$(read_param "capsule_url")" || {
    __err E "config: capsule_url missing."
    return 1
  }

  local index rssfile
  index="${src}index.gmi"

  [[ -s "$index" ]] || {
    __err E "index.gmi: no such file."
    return 1
  }
  
  rssfile="${src}feed/rss.xml"
  [[ -d "${src}feed" ]] || mkdir "${src}feed" || return 1
  
  local now
  now="$(_date "%F %T %Z")"
  header="${header/\[TITLE\]/$title}"
  header="${header/\[DATE\]/$now}"
  header="${header/\[URL\]/$url}"
  header="${header/\[DESCRIPTION\]/$desc}"

  echo "$header" > "$rssfile"

  local line newitem itemurl itemdate itemtitle
  while read -r line; do
    [[ $line =~ ^=\>\ (.+)\ ([0-9]{4}/[0-9]{2}/[0-9]{2})\ (.+)$ ]] && {
      newitem="$item"
      itemurl="$url/${BASH_REMATCH[1]}"
      itemdate="${BASH_REMATCH[2]}"
      itemtitle="${BASH_REMATCH[3]}"
      newitem="${newitem/\[URL\]/$itemurl}"
      newitem="${newitem/\[DATE\]/$itemdate}"
      newitem="${newitem/\[ITEMTITLE\]/$itemtitle}"
      newitem="${newitem/\[ITEMDESCRIPTION\]/$itemtitle}"
      echo "$newitem" >> "$rssfile"
    }
  done < <(tac "$index")

  echo "$footer" >> "$rssfile"

  __err M "rss generated."
}
