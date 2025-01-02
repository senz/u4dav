#!/bin/sh
set -e

BINARY=${BINARY:-"caddy"}
CONFIG=${CONFIG:-"/etc/caddy/Caddyfile"}

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

# Trap common signals and forward them to the handle_signal function
trap 'handle_signal SIGTERM' SIGTERM
trap 'handle_signal SIGINT' SIGINT
trap 'handle_signal SIGHUP' SIGHUP

# generate password hash
PASSWORD_HASH="$(echo "$PASSWORD" | $BINARY hash-password --algorithm bcrypt)"

export BASIC_AUTH_USERNAME="$USERNAME"
export BASIC_AUTH_PASSWORD="$PASSWORD_HASH"
export XDG_DATA_HOME="$HOME/caddy-config"
$BINARY run --config $CONFIG --adapter caddyfile &
child=$!

# Wait for the child process to finish
wait "$child"
