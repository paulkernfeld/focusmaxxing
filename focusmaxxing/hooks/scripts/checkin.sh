#!/bin/bash
set -euo pipefail

input=$(cat)
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
  exit 0
fi

if ! tail -n 50 "$transcript_path" | grep -qi "focusmaxxing"; then
  exit 0
fi

ANCHOR="Can you touch your anchor — breath, feet, sound, wherever you sit?"
NON_ANCHOR=(
  "While you waited for this response, where did your attention go?"
  "How's the body right now — one word?"
  "What emotion is here — one or two words?"
  "Optimistic or pessimistic about the task right now?"
  "Still on the approach you set, or has it shifted?"
  "Any alt-tabbing, phone-checking, or perfectionism creeping in?"
)

if (( RANDOM % 2 == 0 )); then
  question="$ANCHOR"
else
  question="${NON_ANCHOR[$((RANDOM % ${#NON_ANCHOR[@]}))]}"
fi

context="End your response with this check-in question (paraphrased in your own voice): $question"

jq -nc \
  --arg ctx "$context" \
  '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $ctx}}'
