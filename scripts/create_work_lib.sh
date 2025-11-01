#!/usr/bin/env bash
# mk_work  [DIR]  [--force]
#   Create ModelSim / QuestaSim library "work" in DIR (default = .).
#   With --force, remove any existing work/ first.

set -euo pipefail

DIR="."
FORCE=0

# ---- argument parsing ------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1 ; shift ;;
    -h|--help)
      echo "Usage: $0 [DIR] [--force]"
      echo "  DIR   : target directory (default: current directory)"
      echo "  --force : delete existing work/ before creating"
      exit 0
      ;;
    *)  DIR="$1" ; shift ;;
  esac
done

WORKLib="$DIR/work"

# ---- sanity checks ---------------------------------------------
if ! command -v vlib >/dev/null 2>&1; then
  echo "Error: vlib not found in PATH (ModelSim/QuestaSim installed?)" >&2
  exit 1
fi

# ---- optional removal ------------------------------------------
if [[ -d "$WORKLib" ]]; then
  if (( FORCE )); then
    echo "Removing old library: $WORKLib"
    rm -rf "$WORKLib"
  else
    echo "Library already exists: $WORKLib (use --force to replace)" >&2
    exit 1
  fi
fi

# ---- create library --------------------------------------------
echo "Creating library 'work' in $DIR"
vlib "$WORKLib"
echo "Done."
