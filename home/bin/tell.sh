#!/usr/bin/env bash
# Takes a query as fisrt argument and a file as second argument, queries ollama and prints the result

PROMPT="$1"
CONTEXT="$(cat $2)"
MODEL="${3:-llama3}"

ollama run "$MODEL" "Be short and precise. $PROMPT\n$CONTEXT"
