#!/bin/bash

FLAVOR=$1
YEAR=2021

if [[ "$FLAVOR" == "spirit" ]]; then
  YEAR=2019
fi

./scripts/prepare_assets.sh $FLAVOR $YEAR
