#!/bin/sh
set -eu

if [ -n "${CONNECT_IQ_SDK_HOME:-}" ]; then
  sdk_dir=$CONNECT_IQ_SDK_HOME
else
  sdk_config="${HOME:?HOME must be set}/Library/Application Support/Garmin/ConnectIQ/current-sdk.cfg"
  if [ ! -r "$sdk_config" ]; then
    echo "Connect IQ SDK configuration not found: $sdk_config" >&2
    echo "Install the SDK with Garmin's SDK Manager or set CONNECT_IQ_SDK_HOME." >&2
    exit 1
  fi
  sdk_dir=$(cat "$sdk_config")
fi

if [ -z "$sdk_dir" ] || [ ! -d "$sdk_dir" ]; then
  echo "Connect IQ SDK directory not found: $sdk_dir" >&2
  echo "Check the selected SDK or set CONNECT_IQ_SDK_HOME to an installed SDK." >&2
  exit 1
fi

printf '%s\n' "$sdk_dir"
