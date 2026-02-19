#!/bin/sh
set -e

if [ -z "$PASSWORD" ]; then
    echo "Error: PASSWORD environment variable is not set."
    exit 1
fi

if [ -z "$USERNAME" ]; then
    echo "Error: USERNAME environment variable is not set."
    exit 1
fi

# Function to handle signals and propagate them to the child process
handle_signal() {
    kill -s "$1" "$child" 2>/dev/null
}

trap 'handle_signal SIGTERM' SIGTERM
trap 'handle_signal SIGINT' SIGINT
trap 'handle_signal SIGHUP' SIGHUP

RCLONE_ADDR="${RCLONE_ADDR:-:80}"
RCLONE_LOG_LEVEL="${RCLONE_LOG_LEVEL:-INFO}"

rclone serve webdav :local:/media \
    --addr "$RCLONE_ADDR" \
    --log-level "$RCLONE_LOG_LEVEL" \
    --user "$USERNAME" \
    --pass "$PASSWORD" &
child=$!

wait "$child"
