#!/bin/bash

#Setup Environment variables
set -xeu
cd "( dirname "$0")"
source export-env.sh

#Create backup directory
mkdir -p $BACKUP_DIR
