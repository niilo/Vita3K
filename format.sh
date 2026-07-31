#!/usr/bin/env bash
set -euo pipefail

CLANG_FORMAT_BIN="${CLANG_FORMAT_BIN:-clang-format}"

format_args=(-i)
if [[ "${1:-}" == "--check" ]]; then
    format_args=(--dry-run --Werror)
elif [[ $# -gt 0 ]]; then
    echo "Usage: $0 [--check]" >&2
    exit 2
fi

find vita3k tools/gen-modules tools/native-tool \( -name '*.cpp' -o -name '*.h' \) -print0 \
    | xargs -0 "$CLANG_FORMAT_BIN" "${format_args[@]}"
