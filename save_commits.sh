#!/bin/sh
function commit_hash() {
    echo $(git rev-parse HEAD)
}

SUBMODULE_PATHS=$(git config --file .gitmodules --get-regexp path | awk '{print $2}')
BASE_DIR=$PWD

echo "$BASE_DIR//$(commit_hash)"
for SUBMODULE_PATH in $SUBMODULE_PATHS; do
    cd "$SUBMODULE_PATH"
    echo "$SUBMODULE_PATH//$(commit_hash)"
    cd $BASE_DIR
done
