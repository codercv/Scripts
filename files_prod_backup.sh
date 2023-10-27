#!/bin/bash

EXCLUDE="--exclude='*.zip'"
EXCLUDE="$EXCLUDE --exclude='*.gz'"
EXCLUDE="$EXCLUDE --exclude='./var/[^\.htaccess]*'"
EXCLUDE="$EXCLUDE --exclude='./pub/[^\.htaccess]*'"
EXCLUDE="$EXCLUDE --exclude='./generated/[^\.htaccess]*'"

ARCHNAME="gezonderwinkelen.nl"
ARCHNAME="`date +$ARCHNAME""_files_%Y%m%d.%H%M%S.tar.gz`"

FOLDERFULLPATH='/data/web/magento2/'

bash -c "tar $EXCLUDE -czf $ARCHNAME -C $FOLDERFULLPATH ."
