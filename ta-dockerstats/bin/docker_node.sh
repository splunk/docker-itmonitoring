#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
"$DOCKER_BIN" node ls  \
  | tail -n +2 \
  | sed -E "s/\s\s+/,/g"