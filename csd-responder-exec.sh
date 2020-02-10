#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$DIR/csd-responder.sh "$@" 2>&1 | sed -e "s/^/ [csd] /"
