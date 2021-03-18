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

**gmi** has been tested on a **self-hosted server only**.

## Dependencies

bash, coreutils, findutils, fzf, nano (optional), rsync, sed, ssh

## Installation

Clone this repository and:

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

`articles_section_name = Articles`  
`articles_section_delimiter = ---`  

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

Once everything is set up, enter: `gmi init`  
It creates the main directory structure and files for the capsule.

**For convenience when deploying the capsule, you might want to disable password authentication for rsync on the server. To do so:**

On the server, enter: `sudo visudo`  
And add this line: `user ALL= NOPASSWD:/usr/bin/rsync`  
(Replace "user" by your username)

**Also, make sure the EDITOR environment variable is set. Gmi needs it to launch your editor of choice.**

Then, you're good to go.

## Basic usage

**To customize your main page, enter:** `gmi index`

**To create an article, enter:** `gmi new "My New Article"`  
When finished, a link to the article is added to the main index.gmi.

**To deploy the capsule on the server:** `gmi deploy`  
RSS feed is generated each time you use this command.

**To add a microblog entry, enter:** `gmi post "Hello, World!"`  
Changes are automatically deployed to the server.

**To view list of already created articles:** `gmi articles`  
Selected article then can be:

* Edited
* Renamed
* Archived
* Deleted

## Directory structure and files

Articles are stored in a YYYY/MM/DD/ID/ fashion.

## Article title and renaming

**gmi** assumes the first line of the file is the article's title.

```
1 | # My New Article Title
2 |
3 | 2021/03/15
4 |
5 | Article content
```

**When the title is changed inside the file, it is also changed in the main page.**

```
=> 2021/03/15/1/index.gmi 2021/03/15 My New Article Title
```

## Options

| Option | Description |
|:-------|:------------|
| init    | Create initial capsule directory structure and files. |
| new [title] | Create a new article. |
| post [msg]  | Post a new microblog entry. |
| deploy | Deploy capsule on server. |
| deploy-micro | Deploy micro.gmi file only. |
| articles | Display article list. |
| index | Open main index for editing. |
| micro | Open micro.gmi for editing. |
| archive-index | Open main archive index. |
| archived | Display archived article list. |
| auto-archive | Proceed archiving of older articles. |

When an article is selected, more options are shown:

| Option | Description |
|:-------|:------------|
| edit    | Open article for editing. |
| rename  | Rename the article. |
| archive | Archive the article. |
| delete  | Delete the article. |

