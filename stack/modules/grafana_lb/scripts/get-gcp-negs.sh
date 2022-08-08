#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

eval "$(jq -r '@sh "SERVICE=\(.service)"')"

SERVICE="$SERVICE"

gcloud beta compute network-endpoint-groups list --format json |  jq --arg target "$SERVICE" '[.[] | select( .name | contains($target))] | [.[] | { (.selfLink): .selfLink }] | add'