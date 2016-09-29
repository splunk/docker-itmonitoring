#!/bin/bash

DOCKER_BIN=$(dirname "$0")/docker
"$DOCKER_BIN" inspect $("$DOCKER_BIN" ps -aq) | jq -c -M -r ".[]"
