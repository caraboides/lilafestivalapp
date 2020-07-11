#!/bin/bash

set -a
source .env
set +a

FLAVOR=$1
FESTIVAL_ID="${FLAVOR}_${2}"

mkdir -p assets
rm -rf assets/*
cp -r flavor_assets/$FLAVOR/* assets
curl -f $FESTIVAL_HUB_BASE_URL/bands?festival=$FESTIVAL_ID -o assets/bands.json
curl -f $FESTIVAL_HUB_BASE_URL/schedule?festival=$FESTIVAL_ID -o assets/schedule.json
flutter clean
