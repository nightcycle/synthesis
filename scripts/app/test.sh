#!/usr/bin/env bash
set -e
cargo test --features "all" -- --test-threads=1