#!/usr/bin/env bash

##Extract output to log file
DATE=$(date +"%Y%m%d_%H%M%S")
LOGFILE="backup-stdout-$DATE.log"
DIRECTORY="backup-$DATE"
mkdir -p ~/backup-storage/$DIRECTORY
#exec &> ./backup-storage/$DIRECTORY/$LOGFILE

##Run backup of Opsman Installation
#Create Opsman backup directory
mkdir -p ./om-installation 
echo "Running backup of Opsman Installation......"
./export-om-installation.sh
if [ $? -eq 0 ]
then
  echo "Backup Opsman Installation......DONE"
  #Move Opsman installation configuration to centralized location
  cp -var ./om-installation/ ~/backup-storage/$DIRECTORY
  rm -vrf ./om-installation
else
  echo "Backup Opsman Installation......FAILED"
  echo "Exiting..."
  exit 1
fi

##Run Check Opsman Status script
echo "Running Check Opsman Status Script......"
./check-opsman-status.sh
if [ $? -eq 0 ]
then
  echo "Opsman Status check......DONE"
else
  echo "Opsman status check......FAILED"
  echo "Exiting..."
  exit 1
fi

#Run Lock PKS script
echo "Locking Access to PKS API server......"
./lock-pks.sh
if [ $? -eq 0 ]
then
  echo "Lock access to PKS API server......DONE"
else
  echo "Lock access to PKS API server......FAILED"
  echo "Unlocking access to PKS API server......"
  ./unlock-pks.sh
  echo "Exiting..."
  exit 1
fi

#Run BOSH Director Backup script
echo "Running BOSH Director backup Script......"
mkdir -p ./director-backup-artifact
./bbr-backup-director.sh
if [ $? -eq 0 ]
then
  echo "BOSH Director backup......DONE"
  #Move artifact to centralized location
  cp -var ./director-backup-artifact/ ~/backup-storage/$DIRECTORY
  rm -vrf ./director-backup-artifact
else
  echo "BOSH Director backup......FAILED"
  echo "Running Cleanup script"
  ./bbr-cleanup-director.sh
  echo "Unlocking access to PKS API server......"
  ./unlock-pks.sh
  echo "Exiting..."
  exit 1
fi

#Run PKS Backup script
echo "Running PKS backup Script......"
mkdir -p ./pks-backup-artifact
./bbr-backup-pks.sh
if [ $? -eq 0 ]
then
  echo "PKS backup......DONE"
  #Move artifact to centralized location
  cp -var ./pks-backup-artifact/ ~/backup-storage/$DIRECTORY
  rm -vrf ./pks-backup-artifact
else
  echo "PKS backup......FAILED"
  echo "Running Cleanup script"
  ./bbr-cleanup-pks.sh
  echo "Unlocking access to PKS API server......"
  ./unlock-pks.sh
  echo "Exiting..."
  exit 1
fi

#Run PKS Backup script
echo "Running PKS Cluster backup Script......"
mkdir -p ./pks-clusters-backup-artifact
./bbr-backup-pks-clusters.sh
if [ $? -eq 0 ]
then
  echo "PKS Cluster backup......DONE"
  #Move artifact to centralized location
  cp -var ./pks-clusters-backup-artifact/ ~/backup-storage/$DIRECTORY
  rm -vrf ./pks-clusters-backup-artifact
else
  echo "PKS Cluster backup......FAILED"
  echo "Running Cleanup script"
  ./bbr-cleanup-pks-clusters.sh
  echo "Unlocking access to PKS API server......"
  ./unlock-pks.sh
  echo "Exiting..."
  exit 1
fi

#Run Unlock PKS script
echo " Running Unlock PKS Script......"
./unlock-pks.sh
if [ $? -eq 0 ]
then
  echo "Unlocking access to PKS API server......DONE"
else
  echo "Unlocking access to PKS API server......FAILED"
  exit 1
fi