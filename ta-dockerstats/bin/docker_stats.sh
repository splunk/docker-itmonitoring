#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
"$DOCKER_BIN" stats --no-stream=true $("$DOCKER_BIN" ps -q) \
  | tail -n +2 \
  | grep -Ev "\w+\s+0\.00%\s+0\sB/0\sB\s+0\.00%\s+0\sB/0\sB\s+0\sB/0\sB" \
  | sed 's/\//  /g' \
  | sed -E 's/\s\s+/,/g' \
  | sed 's/KiB,/ KiB,/g; s/MiB,/ MiB,/g; s/GiB,/ GiB,/g; s/TiB,/ KiB,/g; s/kB,/ kB,/g; s/MB,/ MB,/g; s/GB,/ GB,/g'
