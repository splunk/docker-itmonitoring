#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
"$DOCKER_BIN" stats --no-stream=true $("$DOCKER_BIN" ps -q) \
  | tail -n +2 \
  | grep -Ev "\w+\s+0\.00%\s+0\sB/0\sB\s+0\.00%\s+0\sB/0\sB\s+0\sB/0\sB" \
  | sed 's/\//  /g' \
  | sed -E 's/\s\s+/,/g'
