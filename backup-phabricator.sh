#!/usr/bin/env bash
##
# Credits to @vnykmshr
# Reproduced from his blog post http://www.vnykmshr.com/phabricator-automate-data-backup-using-dropbox/
##

set +x

DATE=`date +%Y%m%d`
DUMP=phabricator.dump.$DATE.tar.bz2
REPO=phabricator.repo.$DATE.tar.bz2
CODE=phabricator.code.$DATE.tar.bz2

## Database dump
# take mysql data dump of Phabricator database
# update mysql credentials as needed
mysqldump -uroot -p***** --single-transaction --quick --all-databases > dump.sql
# compress the dump file
tar -Pcjf $DUMP dump.sql

## Phabricator hosted repositories archive
tar -Pcjf $REPO /var/repo

## Phabricator source code archive including arcanist and libphutil
tar -Pcjf $CODE /opt/taskman

## Upload the dump files to Dropbox
./dropbox_uploader.sh upload *.$DATE.tar.bz2 /

# cleanup local files
rm dump.sql $DUMP $REPO $CODE
