#!/bin/bash

#Prompt User for details of Opsman
echo "Enter Hostname/IP for OPSMAN:"
read OPSMAN_HOSTNAME

echo "Enter OPSMAN Username:"
read OPSMAN_USERNAME

echo "Enter OPSMAN Password:"
read OPSMAN_PASSWORD

#Prompt User for location of binaries
#echo "Enter Directory for Binaries(Press [ENTER] for default: /usr/local/bin):"
#read BACKUP_BINARY_DIR
#if [ -z "$BACKUP_BINARY_DIR" ]
#then
#	BACKUP_BINARY_DIR=/usr/local/bin
#	echo "Default directory set: $BACKUP_BINARY_DIR"
#else
#	echo "$BACKUP_BINARY_DIR entered"
#fi

#Create environment variables
cat << EOF > export-env.sh
#OPSMAN Credentials environment variables
export SKIP_SSL_VALIDATION=true
export OPSMAN_URL=https://$OPSMAN_HOSTNAME/
export OPSMAN_USERNAME=$OPSMAN_USERNAME
export OPSMAN_PASSWORD="$OPSMAN_PASSWORD"
#export OPSMAN_PRIVATE_KEY=

#Directory Environment variables
export BACKUP_DIR=$HOME/backup-storage/backup-\$(date +"%Y%m%d_%H%M%S") 
EOF
