#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: ./check.sh [--diff-only|--format-only|--cmake-only]

Run read-only checks useful before submitting a change.
With no option, run all checks.
EOF
}

run_diff_check() {
    echo "==> Checking whitespace errors"
    git diff --check
    git diff --cached --check
}

run_format_check() {
    echo "==> Checking C/C++ formatting"
    if ! command -v clang-format >/dev/null 2>&1 && [[ -z "${CLANG_FORMAT_BIN:-}" ]]; then
        echo "clang-format is required for the format check; install it or set CLANG_FORMAT_BIN." >&2
        return 1
    fi
    ./format.sh --check
}

run_cmake_check() {
    echo "==> Validating CMake presets"
    if ! command -v cmake >/dev/null 2>&1; then
        echo "cmake is required for the CMake check." >&2
        return 1
    fi
    cmake --list-presets >/dev/null
}

mode="all"
if [[ $# -gt 1 ]]; then
    usage >&2
    exit 2
elif [[ $# -eq 1 ]]; then
    case "$1" in
        --diff-only)
            mode="diff"
            ;;
        --format-only)
            mode="format"
            ;;
        --cmake-only)
            mode="cmake"
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            usage >&2
            exit 2
            ;;
    esac
fi

case "$mode" in
    all)
        run_diff_check
        run_format_check
        run_cmake_check
        ;;
    diff)
        run_diff_check
        ;;
    format)
        run_format_check
        ;;
    cmake)
        run_cmake_check
        ;;
esac

echo "Checks passed."
