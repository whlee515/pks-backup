#I/bin/bash

#Prompt User for details of Opsman
echo "Enter Hostname/IP for OPSMAN:"
read OPSMAN_HOSTNAME

echo "Enter OPSMAN Username:"
read OPSMAN_USERNAME

echo "Enter OPSMAN Password:"
read OPSMAN_PASSWORD

cat << EOF > export-env.sh
export SKIP_SSL_VALIDATION=true
export OPSMAN_URL=https://$OPSMAN_HOSTNAME/
export OPSMAN_USERNAME=$OPSMAN_USERNAME
export OPSMAN_PASSWORD="$OPSMAN_PASSWORD"
#export OPSMAN_PRIVATE_KEY=
EOF
