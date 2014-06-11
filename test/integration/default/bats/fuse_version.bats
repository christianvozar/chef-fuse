#!/usr/bin/env bats

export EXPECTED_FUSE_VERSION="2.9.3"

@test "FuSE $EXPECTED_FUSE_VERSION is installed" {
  test -f /usr/local/lib/libfuse.so.$EXPECTED_FUSE_VERSION
}

@test "FuSE symlinks are configured." {
  test -L /usr/local/lib/libfuse.so
  test -L /usr/local/lib/libfuse.so.2
}
