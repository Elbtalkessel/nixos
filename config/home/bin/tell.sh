#!/usr/bin/env bash

FILEPATH=$1
PROMPT=$2
MODEL=${3:-llama3}

echo "Running $MODEL on $FILEPATH with prompt: $PROMPT"
result=$(ollama run $MODEL "$PROMPT $(cat $FILEPATH)")
echo "$result" > $FILEPATH
