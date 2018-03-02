#!/bin/bash
exec /etc/init.d/xvfb start  2> /dev/null &
exec "$@"
