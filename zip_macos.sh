#!/bin/sh
set -e

# Build the project
cargo build --workspace --profile ${ARIA_BUILD_CONFIG:-release}

BIN_NAME="aria"
PROFILE="${ARIA_BUILD_CONFIG:-release}"
TARGET_DIR="target/$PROFILE"
ARCHIVE_NAME="${BIN_NAME}.tar.gz"

# Start with the binary
tar -czf "$ARCHIVE_NAME" -C "target/$PROFILE" "$BIN_NAME"
# Add lib directory if it exists
if [ -d lib ]; then
    tar -rf "${ARCHIVE_NAME%.gz}" -C . lib
fi
# Add lib-test directory if it exists
if [ -d lib-test ]; then
    tar -rf "${ARCHIVE_NAME%.gz}" -C . lib-test
fi

# Compress the final archive
if [ -d lib ] || [ -d lib-test ]; then
    gzip "${ARCHIVE_NAME%.gz}"
fi
