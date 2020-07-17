#!/bin/bash

#Setup debug flag and source directory
set -xeu
cd "$(dirname "$0")"

#Setup environment variables
source export-env.sh

##Extract output to log file
DATE=$(date +"%Y%m%d_%H%M%S")
#BACKUP_DIR=$HOME/backup-storage/backup-$DATE
#mkdir -p $BACKUP_DIR 

##Run backup of Opsman Installation
#Create Opsman backup directory
mkdir -p ./om-installation 
echo "Running backup of Opsman Installation......"
bash export-om-installation.sh
if [ $? -eq 0 ]
then
  echo "Backup Opsman Installation......DONE"
  #Move Opsman installation configuration to centralized location
  cp -var ./om-installation/ $BACKUP_DIR/
  rm -vrf ./om-installation
else
  echo "Backup Opsman Installation......FAILED"
  echo "Exiting..."
  exit 1
fi

##Run Check Opsman Status script
echo "Running Check Opsman Status Script......"
bash check-opsman-status.sh
if [ $? -eq 0 ]
then
  echo "Opsman Status check......DONE"
else
  echo "Opsman status check......FAILED"
  echo "Exiting..."
  exit 1
fi

