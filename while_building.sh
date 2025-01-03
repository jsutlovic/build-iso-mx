#!/bin/bash

# This script is intended to wrap a build script and run a task at intervals
# (check filesystem sizes) until the build script stops.

interval=${INTERVAL:2}
track_output=${TRACK_OUTPUT:fs_tracking.json}
build_update=${BUILD_UPDATE:./chksize.sh}

bash -c "while :; do $build_update >> $track_output; sleep $interval; done"

trap 'kill $(jobs -p) 2>/dev/null' EXIT

bash -c "$@"

kill $(jobs -p)
