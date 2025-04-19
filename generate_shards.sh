#!/bin/bash

START=$((2**68))
END=$((2**69))
STEP=1000000

> shards.txt
while [ $START -lt $END ]; do
    SHARD_END=$((START + STEP - 1))
    echo "$START:$SHARD_END" >> shards.txt
    START=$((START + STEP))
done

