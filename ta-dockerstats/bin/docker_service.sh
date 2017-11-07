#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
"$DOCKER_BIN" service ls  \
  | tail -n +2 \
  | sed -e "s/,/ /g" \
  | sed -E "s/\s\s+/,/g"


  docker service ls | tail -n +2 | sed -e "s/ /,/g"