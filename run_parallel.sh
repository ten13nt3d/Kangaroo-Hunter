#!/bin/bash

TARGET="61eb8a50c86b0584bb727dd65bed8d2400d6d5aa"
PARALLEL_JOBS=1  # Para 1 GPU, puedes dejar 1. Si tienes más, aumenta.

docker-compose build

cat shards.txt | parallel -j $PARALLEL_JOBS --line-buffer \
  'docker-compose run --rm kangaroo ./Kangaroo -r {} -t '"$TARGET"' -p 256'

