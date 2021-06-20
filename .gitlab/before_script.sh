#!/bin/bash
# exit when any command fails
set -e
# echo off
set -x
# Create the config
cat <<EOF > auth.ini
[${EXPERIMENT}]
BOT_HANDLE = @${BOT_HANDLE}
CONSUMER_KEY = ${CONSUMER_KEY}
CONSUMER_SECRET = ${CONSUMER_SECRET}
ACCESS_TOKEN = ${ACCESS_TOKEN}
ACCESS_TOKEN_SECRET = ${ACCESS_TOKEN_SECRET}
EOF
# Create the SSH directory and give it the right permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh
eval "$(ssh-agent -s)"
set -x
ssh-add <(echo "$GIT_SSH_PRIV_KEY")
echo "$GIT_SSH_PRIV_KEY" > ~/.ssh/id_rsa
set +x
chmod 600 ~/.ssh/id_rsa
ssh-keyscan -p 7999 gitlab.cern.ch > ~/.ssh/known_hosts
set -x
# # Set git user name and email
git config --global user.email "${GITMAIL}"
git config --global user.name "${GITNAME}"
git config --global http.postBuffer 1048576000
git config --global https.postBuffer 1048576000
# git config --global http.postBuffer 524288000
# git config --global https.postBuffer 524288000

set +x
echo "auth.ini created for ${EXPERIMENT}"

cat /etc/ImageMagick-6/policy.xml | grep "resource\|PDF"