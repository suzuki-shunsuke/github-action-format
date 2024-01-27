#!/usr/bin/env bash

set -euo pipefail

tempfile=$(mktemp)
eval "$INPUT_COMMAND" >"$tempfile"
if [ 0 -eq "$(wc -l <"$tempfile")" ]; then
	rm "$tempfile"
	exit 0
fi

echo "::error Files aren't formatted"

if [ "$SKIP_PUSH" = true ]; then
	rm "$tempfile"
	exit 1
fi

# shellcheck disable=SC2046
ghcp commit -r "$GITHUB_REPOSITORY" -b "$GITHUB_HEAD_REF" \
	-m "$INPUT_COMMIT_MESSAGE" \
	-C "$ROOT_DIR" $(cat "$tempfile")
rm "$tempfile"
exit 1
