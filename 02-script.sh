#!/bin/bash

#Setup debug flag and source directory
set -xeu
cd "$(dirname "$0")"

#Setup environment variables
source export-env.sh

#Setup variables and backup directory
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_BASE_DIR=$HOME/backup-storage/
BACKUP_LOG_DIR=$HOME/backup-log/
BACKUP_DIR=$HOME/backup-storage/backup-$DATE
DEBUG_TEXT="\033[1;33m[Backup Script Debug] \033[0m"
mkdir -p $BACKUP_DIR 

#/usr/local/bin/om version
#bash $BACKUP_SCRIPT_DIR/export-om-installation.sh
om version

#Run Housekeeping to keep the latest 7 copies of backup artifacts
ls -d -1t $BACKUP_BASE_DIR/* | tail -n +8 | xargs rm -rvf
ls -it $BACKUP_LOG_DIR/* | tail -n +8 | xargs rm -rvf

