#!/usr/bin/env bash
# vlog_compile  [file|dir]   # defaults to current directory
# Interactive picker for ModelSim/Questa vlog.
#   -tree shows grouped files
#   -type number, file/folder name, or "all"
#   -runs:  vlog -reportprogress 300 -work work <chosen-files>

set -euo pipefail

shopt -s globstar nullglob          # **/*.v  **/*.sv  work recursively

# colour helpers
R=$'\e[31m' G=$'\e[32m' Y=$'\e[33m' B=$'\e[34m' NC=$'\e[0m'

# work directory
WORK="work"

# 1. decide search root --------------------------------------------------------
ROOT="${1:-.}"                      # arg1 or pwd
[[ -d $ROOT ]] && SEARCH_DIR=$ROOT || SEARCH_DIR=$(dirname "$ROOT")

# 2. build two parallel arrays: (rel-dir)  (file) ------------------------------
declare -a DIR_ARR FILE_ARR
while IFS= read -r -d '' f; do
    DIR_ARR+=( "${f%/*}" )          # directory part
    FILE_ARR+=( "${f##*/}" )       # basename
done < <(find "$SEARCH_DIR" -type f \( -iname '*.v' -o -iname '*.sv' \) -print0 | sort -z)

COUNT=${#FILE_ARR[@]}
[[ $COUNT -eq 0 ]] && { echo "No *.v / *.sv files found under $SEARCH_DIR"; exit 0; }

# 3. pretty-print hierarchical tree ------------------------------------------
echo
echo "Verilog/SystemVerilog files under ${Y}$SEARCH_DIR${NC}"
LAST_DIR=""
for ((i=0; i<COUNT; i++)); do
    dir="${DIR_ARR[i]}"
    file="${FILE_ARR[i]}"
    if [[ $dir != "$LAST_DIR" ]]; then
        echo
        printf "${B}%-4s  📁 %s${NC}\n" "" "$dir"
        LAST_DIR=$dir
    fi
    printf "${G}%3d${NC}     └── %s\n" $((i+1)) "$file"
done
echo

# 4. ask user ------------------------------------------------------------------
echo "Choose:  serial-number | file-name | folder-name | all"
read -rp "> " CHOICE
CHOICE=${CHOICE,,}                  # lower-case

# 5. build FILE_LIST -----------------------------------------------------------
FILE_LIST=()
if [[ $CHOICE == "all" ]]; then
    FILE_LIST=( "${FILE_ARR[@]}" )
else
    # try as number first
    if [[ $CHOICE =~ ^[0-9]+$ ]] && (( CHOICE >= 1 && CHOICE <= COUNT )); then
        idx=$((CHOICE-1))
        FILE_LIST=( "${FILE_ARR[idx]}" )
    else
        # try as exact file name
        for ((i=0; i<COUNT; i++)); do
            [[ ${FILE_ARR[i]} == "$CHOICE" ]] && FILE_LIST+=( "${FILE_ARR[i]}" )
        done
        # if none, treat as folder (prefix match)
        if ((${#FILE_LIST[@]} == 0)); then
            for ((i=0; i<COUNT; i++)); do
                [[ ${DIR_ARR[i]} == *"$CHOICE"* ]] && FILE_LIST+=( "${FILE_ARR[i]}" )
            done
        fi
    fi
fi

((${#FILE_LIST[@]} == 0)) && { echo "Nothing matched '$CHOICE'"; exit 1; }

# 6. prepend directory path ----------------------------------------------------
for ((i=0; i<${#FILE_LIST[@]}; i++)); do
    for ((j=0; j<COUNT; j++)); do
        if [[ ${FILE_ARR[j]} == ${FILE_LIST[i]} ]]; then
            FILE_LIST[i]="${DIR_ARR[j]}/${FILE_LIST[i]}"
            break
        fi
    done
done

# 7. compile -------------------------------------------------------------------
# echo
# echo "Compiling:"
# printf '  %s\n' "${FILE_LIST[@]}"
# echo
# mkdir -p "$ROOT/log"
# vlog -reportprogress 300 -work $WORK "${FILE_LIST[@]}" >> logmsg
# "$ROOT/log/compile.log"

# echo
# echo "${G}Done.${NC}"

# 7. compile -------------------------------------------------------------------
echo
echo "Compiling:"
printf '  %s\n' "${FILE_LIST[@]}"
echo

LOG="$ROOT/log/vlog_run.log"
echo "$(basename $WORK) Logging to $LOG"
{
  echo "=== vlog started $(date) ==="
  printf 'vlog -reportprogress 300 -work %s' "$WORK"
  printf ' %q' "${FILE_LIST[@]}"
  echo
  vlog -reportprogress 300 -work "$WORK" "${FILE_LIST[@]}"
  echo "=== vlog finished $(date) ==="
} | tee -a "$LOG"
