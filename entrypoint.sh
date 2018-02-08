#!/bin/bash
# export HOME=/home/plone
exec /etc/init.d/xvfb start  2> /dev/null &
exec "$@"
