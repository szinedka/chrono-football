#!/bin/sh
set -eu

if [ "$#" -ne 0 ]; then
  echo "Usage: $0" >&2
  exit 2
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
sdk_dir=$(sh "$script_dir/garmin-sdk-path.sh")

launcher="$sdk_dir/bin/connectiq"
if [ ! -x "$launcher" ]; then
  echo "Connect IQ simulator launcher not found or not executable: $launcher" >&2
  echo "Check the selected SDK or set CONNECT_IQ_SDK_HOME to an installed SDK." >&2
  exit 1
fi

exec "$launcher"
