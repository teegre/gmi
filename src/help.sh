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
# M : 2021/03/15
# D : Help screen.

help() {
cat << 'EOB' >&2
gmi: gemini capsule generator

Usage:
    gmi
    gmi <option>
    gmi <option> <value>

Options:
    Invoked without argument, display a list of commands.

    init          - create initial capsule directory structure
                    and files.
    new [title]   - create a new article.
    post [msg]    - post a new microblog entry.
    articles      - list articles.
    archived      - list archived articles.
    index         - open main index.gmi
    micro         - open micro.gmi.
    archive-index - open main archive index.
    deploy        - deploy capsule on server.
    deploy-micro  - deploy micro.gmi on server.
    auto-archive  - archive older articles.
    help          - show this help and exit.
EOB
}
