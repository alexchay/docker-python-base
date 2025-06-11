#!/bin/bash

# This script is focused on testing the Docker image itself (e.g., checking that files, binaries, or configurations are present in the image,
# but not actually running the containerized application).

set -euo pipefail

# Get the directory of this script
scripts_dir=$(dirname "$0")

# Run this script to check PATH
# shellcheck disable=SC1091
. $scripts_dir/check_path.sh