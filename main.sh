#!/usr/bin/env bash

set -euo pipefail

tempfile=$(mktemp)
eval "$INPUT_COMMAND" >"$tempfile"
if [ 0 -eq "$(wc -l <"$tempfile")" ]; then
	rm "$tempfile"
	exit 0
fi

echo "::error :: Files aren't formatted"

if [ "$SKIP_PUSH" = true ]; then
	rm "$tempfile"
	exit 1
fi

if ! ghcp -v; then
	echo "::error :: ghcp is required to push a commit. Please install https://github.com/int128/ghcp"
	exit 1
fi

branch=${GITHUB_HEAD_REF:-$GITHUB_REF}

if [[ "$branch" =~ ^refs/tags/ ]]; then
	exit 1
fi

echo "::notice :: Pushing a commit using ghcp to format code"

# shellcheck disable=SC2046
ghcp commit -r "$GITHUB_REPOSITORY" -b "$branch" \
	-m "$INPUT_COMMIT_MESSAGE" \
	-C "$ROOT_DIR" $(cat "$tempfile")
rm "$tempfile"
exit 1
