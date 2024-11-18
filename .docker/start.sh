#!/bin/sh

# We'll use this script to manage starting and stopping this container gracefully.
# It idles at about 00.01 CPU % allotted to the container, you can verify
# by running `docker stats` after you start a container that uses this.

set -e

shutD () {
    printf "%s" "Shutting down the container gracefully..."

    # You can run clean commands here!

    last_signal="15"
}

# Wait for signals to be sent to this script.
trap 'shutD' TERM INT # 15

echo "Ready"

# Run non-blocking commands here

last_signal=""
# This loop will be forked as a child process, which then we will wait to be
# done, which is what keeps the container running. It has very low CPU usage.
# When this process receives a signal to be stopped, shutd function will run.
while [ "${last_signal}" != "15" ]; do
    sleep 1
done

echo "done"
