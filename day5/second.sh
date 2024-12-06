#!/usr/bin/env bash

INPUT="input.txt"
awk -v RS="" 'NR==1 { first=$0 } NR==2 { second=$0 } END { print first > "/tmp/first.tmp"; print second > "/tmp/second.tmp" }' "$INPUT"
rules=$(</tmp/first.tmp)
tosorts=$(</tmp/second.tmp)
rm /tmp/first.tmp /tmp/second.tmp

count=0
while IFS= read -r line; do
  regex=$(echo "$line" | sed 's/,/|/g')
  regex="($regex)\|($regex)"
  sorted=$(echo "$rules" | grep -E "$regex" | sed 's/|/ /g' | tsort | tr '\n' ' ' | sed 's/ /,/g' | sed 's/,$//')
  if [ "$line" != "$sorted" ]; then
    middle=$(echo "$sorted" | awk -F ',' '{print $int((NF+1)/2)}')
    count=$((count + middle))
  fi
done < <(echo "$tosorts")
echo -e "$count"
