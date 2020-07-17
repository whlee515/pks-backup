#!/bin/bash

set -xeu
cd "$(dirname "$0")"
#BACKUP_SCRIPT_DIR=$( dirname "$0")

env

#source $BACKUP_SCRIPT_DIR/export-env.sh

#env

#/usr/local/bin/om version
#bash $BACKUP_SCRIPT_DIR/export-om-installation.sh
bash export-om-installation.sh
$BACKUP_BINARY_DIR/om version
$BACKUP_BINARY_DIR/om version
