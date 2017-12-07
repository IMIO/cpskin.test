#!/bin/bash

# Add local user
# Either use the HOST_USER_ID if passed in at runtime or fallback

USER_ID=${HOST_USER_ID:-1000}
GROUP_ID=${HOST_GROUP_ID:-1000}
USER_NAME=${HOST_USER_NAME:-plone}

echo "Starting with UID : $USER_ID:$GROUP_ID $USER_NAME"
usermod -u $USER_ID $USER_NAME
groupmod -g $GROUP_ID $USER_NAME
export HOME=/home/plone
# mkdir /home/$USER_NAME/.buildout
# mv /buildout-cache/default.cfg /home/plone/.buildout/default.cfg
# chown -R $USER_ID:$GROUP_ID $HOME
exec /etc/init.d/xvfb start  2> /dev/null &
exec /usr/local/bin/gosu $USER_NAME "$@"
