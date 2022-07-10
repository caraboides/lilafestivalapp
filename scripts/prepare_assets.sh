#!/bin/bash

set -a
source .env
set +a

FLAVOR=$1
YEAR=$2

if [[ -z $FLAVOR ]]; then
  echo "Please specify a flavor: [spirit|party_san]"
  exit 1
fi
if [[ -z $YEAR ]]; then
  echo "Please specify a year, e.g. 2022"
  exit 1
fi

FESTIVAL_ID="${FLAVOR}_${YEAR}"

echo "Preparing assets for ${FESTIVAL_ID}..."

mkdir -p assets
rm -rf assets/*
cp -r flavor_assets/$FLAVOR/* assets
curl -f $FESTIVAL_HUB_BASE_URL/bands?festival=$FESTIVAL_ID -o assets/bands.json
curl -f $FESTIVAL_HUB_BASE_URL/schedule?festival=$FESTIVAL_ID -o assets/schedule.json
flutter clean
