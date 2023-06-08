#!/bin/bash

line_number=0

while IFS= read -r line; do
    ((line_number++))
    
    if ! echo "$line" | jq -e . >/dev/null 2>&1; then
        echo "warning: invalid json: line $line_number"
    fi
done < ../data/train.jsonl
