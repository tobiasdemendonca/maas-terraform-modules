#!/usr/bin/env bash

set -euo pipefail

# If a user doesn't supply required arguments,
# print the usage and exit.
if [ $# -ne 1 ]; then
  echo "Usage: $0 <juju_channel>" >&2
  exit 1
fi

JUJU_CHANNEL="${1:?Error: JUJU_CHANNEL is required}"

sudo snap install juju --channel=$JUJU_CHANNEL

juju version
