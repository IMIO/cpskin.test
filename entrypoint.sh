#!/bin/bash

# Add local user
# Either use the HOST_USER_ID if passed in at runtime or fallback

USER_ID=${HOST_USER_ID:-1000}
GROUP_ID=${HOST_GROUP_ID:-1000}
USER_NAME=${HOST_USER_NAME:-plone}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -d $GROUP_ID -o -c "" -m $USER_NAME
export HOME=/home/$USER_NAME

exec /usr/local/bin/gosu $USER_NAME "$@"
