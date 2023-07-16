#!/bin/bash

FLAVOR=$1
YEAR=2023

if [[ -z $FLAVOR ]]; then
  echo "Please specify a flavor: [spirit|party_san]"
  exit 1
fi

if [[ "$FLAVOR" == "spirit" ]]; then
  YEAR=2019
fi

echo "Switching to festival ${FLAVOR}_${YEAR}..."

./scripts/prepare_assets.sh $FLAVOR $YEAR
