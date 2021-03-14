```
                 _
  __ _ _ __ ___ (_)
 / _` | '_ ` _ \| | gemini
| (_| | | | | | | | capsule
 \__, |_| |_| |_|_| generator
 |___/
```

# gmi: a Gemini Capsule Generator

**gmi** is a Gemini capsule generator to easily manage articles, microblog posts and rss feed from the terminal.

This is work in progress.

*gmi* has been tested on a self-hosted server only.

## Dependencies

bash, coreutils, findutils, fzf, nano (optional), rsync, sed, ssh

## Installation

Clone this repository :

`git clone https://gitlab.com/teegre/gmi.git`

then

`make install`

## Uninstall

`make uninstall`

## Configuration

First, you need to copy the configuration file `/etc/gmi/config` in `$HOME/.config/gmi` and edit it.


`source_dir = ~/.gmi/src`  
Capsule source directory. Defaults to ~/.gmi/src.

`backup_dir = ~/.gmi/bak`  
Backup directory.


`date_format_articles = %F`  
`date_format_micro = %F %T`  
Articles and microblog date format (see `man date` for more on this).

`archive_title = Archive`  
Title of main archive index file.

`yearly_archive_title = Year %y Archive`  
Title of yearly archive index file (%y expands to year).

`rss_title =`  
`rss_description =`  

`server_destination_dir =`  
For instance `user@domain:/path`.

`ssh_identity_file =`  
Optional.

`ssh_port =`  
Optional.

`capsule_url =` 

Once everything is setup:

```
> gmi init
:: init: found source directory
:: init: found backup directory
:: init: creating directories...
:: init: creating files...
:: init: index.gmi [ok]
:: init: archive/index.gmi [ok]
:: init: micro.gmi [ok]
:: init: done.
```
## Options

Invoked without argument, **gmi** display a list of commands and articles:

```
| new
| post
| /home/teegre/.gmi/src/2021/02/07/1/index.gmi
| /home/teegre/.gmi/src/2021/03/06/1/index.gmi
| index
| micro
| archive-index
| archived
| auto-archive
> quit
  gmi version 0.6
  11/11
>
```
Commands can also be invoked directly from the command line.

| Command | Description |
|:--------|:------------|
| init    | Create initial capsule directory structure and files. |
| new [title] | Create a new article. |
| post [msg]  | Post a new microblog entry. |
| index | Open main index for editing. |
| micro | Open micro.gmi for editing. |
| archive-index | Open main archive index. |
| archived | Display archived articles list. |
| auto-archive | Proceed archiving of older articles. |

