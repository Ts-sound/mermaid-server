#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo $SCRIPT_DIR

docker build -t tong_mermaid_server:latest $SCRIPT_DIR/..  2>&1 | tee build.log