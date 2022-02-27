#!/bin/sh
SCRIPT="$(realpath $0)"
BASE_DIR=$(pwd)

SUBMODULE_PATHS=$(git config --file .gitmodules --get-regexp path | awk '{print $2}')

function is_submodule_path() {
    for SUBMODULE_PATH in $SUBMODULE_PATHS; do
        if [[ $SUBMODULE_PATH == $1 ]]; then
            return 0 
        fi
    done
    return 1
}

CHANGED_FILES=$(git diff --name-only)

for FILE in $CHANGED_FILES; do
    if ! is_submodule_path $FILE; then
        echo $FILE
    fi
done

for SUBMODULE in $SUBMODULE_PATHS; do
    cd $SUBMODULE
    SUBMODULE_CHANGES=$($SCRIPT)
    if ! [ -z $SUBMODULE_CHANGES ]; then
        echo $SUBMODULE_CHANGES
    fi
    cd $BASE_DIR
done
