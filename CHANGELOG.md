# 2021/04/11

* gmi, deploy.sh: fixed wrong exit values.

# 2021/03/30

* core.sh: get_date: print creation date in seconds since the epoch of given article.
* config: added article_lifespan parameter for archiving (in months, defaults to 6).
* archive.sh: auto_archive: use of article_lifespan param to determine whether an article must be archived or not.

# 2021/03/19

* Shorter command names.
* init.sh: added creation of favicon.txt file.
* backup.sh: delete capsule before restoring.
* archive.sh: removed use of archive_title configuration parameter.
* list.sh: list function now can display articles or archived articles.

# 2021/03/18

* Written manual page.
* Removed useless configuration parameters.
* Added backup and restore functions.
* Fixed a bug that occured when archiving article with subdirectories.


# 2021/03/16

* config: added articles_section_name, articles_section_delimiter.
* init.sh: now uses previously defined parameters to generate main index.gmi. 
* new.sh: added insert_entry function that insert a link before articles_section_delimiter.
* deploy.sh: removed some useless rsync options.
* gmi: removed options menu display.
* core.sh: updated version number.
* list.sh: removed useless list function + added article date display.
* edit.sh: removed a '#' at the top the file...

# 2021/03/15

* Added help screen
* Added license info headers.

# 2021/03/13

* Splitted script in smaller scripts.
* Refactored.
* In case several articles are published the same day, they are now stored in distinct directories.

# 2021/03/11

* Initial commit.
