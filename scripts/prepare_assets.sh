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
if curl -f $FESTIVAL_HUB_BASE_URL/bands?festival=$FESTIVAL_ID -o assets/bands.json; then
  echo "Successfully loaded bands"
else
  echo "Could not load bands, provide fallback"
  echo -n '{}' >assets/bands.json
fi
if curl -f $FESTIVAL_HUB_BASE_URL/schedule?festival=$FESTIVAL_ID -o assets/schedule.json; then
  echo "Successfully loaded schedule"
else
  echo "Could not load schedule, provide fallback"
  echo -n '{}' >assets/schedule.json
fi
flutter clean
flutter pub get
