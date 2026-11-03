#!/bin/sh
set -eu

if [ "$#" -ne 0 ]; then
  echo "Usage: $0" >&2
  exit 2
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
sdk_dir=$(sh "$script_dir/garmin-sdk-path.sh")
key_path=${CONNECT_IQ_DEVELOPER_KEY:-"${HOME:?HOME must be set}/.config/chrono-football/developer_key.der"}

if [ ! -r "$key_path" ]; then
  echo "Connect IQ developer key not found or not readable: $key_path" >&2
  echo "Set CONNECT_IQ_DEVELOPER_KEY or see the README for key setup." >&2
  exit 1
fi

for tool in monkeyc monkeydo; do
  if [ ! -x "$sdk_dir/bin/$tool" ]; then
    echo "Connect IQ tool not found or not executable: $sdk_dir/bin/$tool" >&2
    exit 1
  fi
done

project_dir="$repo_dir/platforms/garmin"
output_dir="$project_dir/build"
mkdir -p "$output_dir"
"$sdk_dir/bin/monkeyc" -f "$project_dir/monkey-tests.jungle" \
  -d vivoactive5 -y "$key_path" -t -o "$output_dir/chrono-football-tests.prg"

output_file=$(mktemp "${TMPDIR:-/tmp}/chrono-football-tests.XXXXXX")
trap 'rm -f "$output_file"' EXIT

if "$sdk_dir/bin/monkeydo" "$output_dir/chrono-football-tests.prg" vivoactive5 -t >"$output_file" 2>&1; then
  runner_status=0
else
  runner_status=$?
fi
cat "$output_file"

# This SDK's monkeydo returns 1 even when all simulator tests pass.
if [ "$runner_status" -gt 1 ] ||
   ! grep -Eq '^PASSED \(passed=[1-9][0-9]*, failed=0, errors=0\)$' "$output_file"; then
  echo "Garmin tests did not complete successfully (runner exit: $runner_status)." >&2
  exit 1
fi
