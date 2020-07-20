#!/bin/bash

#Setup debug flag and source directory
set -xeu
cd "$(dirname "$0")"

#Setup environment variables
source export-env.sh

#Setup variables and backup directory
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR=$HOME/backup-storage/backup-$DATE
DEBUG_TEXT="\033[1;33m[Backup Script Debug] \033[0m"
mkdir -p $BACKUP_DIR 

##Run backup of Opsman Installation
#Create Opsman backup directory
mkdir -p ./om-installation 
echo -e $DEBUG_TEXT "Running backup of Opsman Installation......"
bash export-om-installation.sh
if [ $? -eq 0 ]
then
  echo -e $DEBUG_TEXT "Backup Opsman Installation......\033[32mDONE\033[0m"
  #Move Opsman installation configuration to centralized location
  cp -var ./om-installation/ $BACKUP_DIR/ 
  rm -vrf ./om-installation
else
  echo -e $DEBUG_TEXT "Backup Opsman Installation......\033[31mFAILED\033[0m"
  echo -e $DEBUG_TEXT "Exiting..."
  exit 1
fi

##Run Check Opsman Status script
echo -e $DEBUG_TEXT "Running Check Opsman Status Script......"
bash check-opsman-status.sh
if [ $? -eq 0 ]
then
  echo -e $DEBUG_TEXT "Opsman Status check......\033[32mDONE\033[0m"
else
  echo -e $DEBUG_TEXT "Opsman status check......\033[31mFAILED\033[0m"
  echo -e $DEBUG_TEXT "Exiting..."
  exit 1
fi

#Run Lock PKS script
echo -e $DEBUG_TEXT "Locking Access to PKS API server......"
bash lock-pks.sh
if [ $? -eq 0 ]
then
  echo -e $DEBUG_TEXT "Lock access to PKS API server......\033[32mDONE\033[0m"
else
  echo -e $DEBUG_TEXT "Lock access to PKS API server......\033[31mFAILED\033[0m"
  echo -e $DEBUG_TEXT "Unlocking access to PKS API server......"
  bash unlock-pks.sh
  echo -e $DEBUG_TEXT "Exiting..."
  exit 1
fi

#Run BOSH Director Backup script
echo -e $DEBUG_TEXT  "Running BOSH Director backup Script......"
mkdir -p ./director-backup-artifact
bash bbr-backup-director.sh
if [ $? -eq 0 ]
then
  echo -e $DEBUG_TEXT "BOSH Director backup......\033[32mDONE\033[0m"
  #Move artifact to centralized location
  cp -var ./director-backup-artifact/ $BACKUP_DIR/
  rm -vrf ./director-backup-artifact
else
  echo -e $DEBUG_TEXT "BOSH Director backup......\033[31mFAILED\033[0m"
  echo -e $DEBUG_TEXT "Running Cleanup script"
  bash bbr-cleanup-director.sh
  echo -e $DEBUG_TEXT "Unlocking access to PKS API server......"
  bash unlock-pks.sh
  echo -e $DEBUG_TEXT "Exiting..."
  exit 1
fi

#Run PKS Backup script
echo -e $DEBUG_TEXT "Running PKS backup Script......"
mkdir -p ./pks-backup-artifact
bash bbr-backup-pks.sh
if [ $? -eq 0 ]
then
  echo -e$DEBUG_TEXT "PKS backup......\033[32mDONE\033[0m"
  #Move artifact to centralized location
  cp -var ./pks-backup-artifact/ $BACKUP_DIR 
  rm -vrf ./pks-backup-artifact
else
  echo -e $DEBUG_TEXT "PKS backup......\033[31mFAILED\033[0m"
  echo -e $DEBUG_TEXT "Running Cleanup script"
  bash bbr-cleanup-pks.sh
  echo -e $DEBUG_TEXT "Unlocking access to PKS API server......"
  bash unlock-pks.sh
  echo -e $DEBUG_TEXT "Exiting..."
  exit 1
fi

#Run PKS Backup script
echo -e $DEBUG_TEXT "Running PKS Cluster backup Script......"
mkdir -p ./pks-clusters-backup-artifact
bash bbr-backup-pks-clusters.sh
if [ $? -eq 0 ]
then
  echo -e $DEBUG_TEXT "PKS Cluster backup......\033[32mDONE\033[0m"
  #Move artifact to centralized location
  cp -var ./pks-clusters-backup-artifact/ $BACKUP_DIR/ 
  rm -vrf ./pks-clusters-backup-artifact
else
  echo -e $DEBUG_TEXT "PKS Cluster backup......\033[31mFAILED\033[0m"
  echo -e $DEBUG_TEXT "Running Cleanup script"
  bash bbr-cleanup-pks-clusters.sh
  echo -e $DEBUG_TEXT "Unlocking access to PKS API server......"
  bash unlock-pks.sh
  echo -e $DEBUG_TEXT "Exiting..."
  exit 1
fi

#Run Unlock PKS script
echo -e $DEBIG_TEXT "Running Unlock PKS Script......"
bash unlock-pks.sh
if [ $? -eq 0 ]
then
  echo -e $DEBUG_TEXT "Unlocking access to PKS API server......\033[32mDONE\033[0m"
else
  echo -e $DEBUG_TEXT "Unlocking access to PKS API server......\033[31mFAILED\033[0m"
  exit 1
fi

echo -e $DEBUG_TEXT "\033[32mBackup completed successfully at $(date)\033[0m"
