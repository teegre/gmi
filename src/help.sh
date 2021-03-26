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
# HELP
# C : 2021/03/15
# M : 2021/03/26
# D : Help screen.

_help() {
cat << 'EOB' >&2
gmi: gemini capsule generator

Usage:
    gmi
    gmi <option>
    gmi <option> <value>

Options:
    init        - create initial capsule file structure.
    new [title] - create a new article.
    post [msg]  - post a new microblog entry.
    list        - list articles.
    lista       - list archived articles.
    idx         - open main index.gmi
    idxm        - open micro.gmi.
    idxa        - open main archive index.
    push        - deploy capsule on server.
    pushm       - deploy micro.gmi on server.
    archive     - archive older articles.
    backup      - create a backup copy of capsule.
    restore     - restore a previous backup copy.
    help        - show this help and exit.
EOB
}
