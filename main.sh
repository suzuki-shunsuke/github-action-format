#!/usr/bin/env bash

set -eu
set -o pipefail

tempfile=$(mktemp)
eval "$INPUT_COMMAND" >"$tempfile"
if [ 0 -eq "$(wc -l <"$tempfile")" ]; then
	exit 0
fi

# Check if EVENT_NAME is either pull_request or pull_request_target
if [ "$EVENT_NAME" != "pull_request" ] && [ "$EVENT_NAME" != "pull_request_target" ]; then
    exit 1
fi

# shellcheck disable=SC2046
ghcp commit -r "$GITHUB_REPOSITORY" -b "$GITHUB_HEAD_REF" \
	-m "$INPUT_COMMIT_MESSAGE" \
	-C "$ROOT_DIR" $(cat "$tempfile")
rm "$tempfile"
exit 1
