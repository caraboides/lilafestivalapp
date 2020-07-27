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

echo "Building app for flavor ${FLAVOR} in production build and release mode..."

if [[ -n $YEAR ]]; then
  echo "Preparing assets for year ${YEAR}..."
  ./scripts/prepare_assets.sh $FLAVOR $YEAR
fi

echo "Starting build..."
flutter build apk --flavor $FLAVOR \
  --dart-define=WEATHER_API_KEY=$WEATHER_API_KEY \
  --dart-define=FESTIVAL_HUB_BASE_URL=$FESTIVAL_HUB_BASE_URL \
  -t lib/main_$FLAVOR.dart \
  --release
