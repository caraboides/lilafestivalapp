#!/bin/bash

set -a
source .env
set +a

BUILD=dev
RELEASE=debug

for i in "$@"; do
  case $i in
  -f=* | --flavor=*)
    FLAVOR="${i#*=}"
    shift
    ;;
  -y=* | --year=*)
    YEAR="${i#*=}"
    shift
    ;;
  -b=* | --build=*)
    BUILD="${i#*=}"
    shift
    ;;
  -r | --release)
    RELEASE=release
    RELEASE_OPTION=--release
    shift
    ;;
  *) # unknown option
    ;;
  esac
done

if [[ -z $FLAVOR ]]; then
  echo "Please specify a flavor: --flavor=<FLAVOR> / -f=<FLAVOR> with FLAVOR = [spirit|party_san]"
  exit 1
fi

echo "Running app for flavor ${FLAVOR} in ${BUILD} build and ${RELEASE} mode..."

if [[ -n $YEAR ]]; then
  echo "Preparing assets for year ${YEAR}..."
  ./scripts/prepare_assets.sh $FLAVOR $YEAR
fi

echo "Starting build..."
flutter run --flavor $FLAVOR \
  --dart-define=APP_ID_SUFFIX=.$BUILD \
  --dart-define=VERSION_NAME_SUFFIX=-$BUILD \
  --dart-define=APP_NAME_PREFIX="[${BUILD}] " \
  --dart-define=WEATHER_API_KEY=$WEATHER_API_KEY \
  --dart-define=FESTIVAL_HUB_BASE_URL=$FESTIVAL_HUB_BASE_URL \
  $RELEASE_OPTION \
  -t lib/main_$FLAVOR.dart
