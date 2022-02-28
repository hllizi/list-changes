#!/bin/sh
SCRIPT="$(realpath $0)"
BASE_DIR=$(pwd)

while getopts "c" OPTION; do
    case $OPTION in
        c) NO_STDIN="true"
    esac
done
shift $(( OPTIND - 1))


function is_member() {
    for ELEMENT in $2; do
        if [[ $ELEMENT == $1 ]]; then
            return 0 
        fi
    done
    return 1
}

#associative array to hold the commits.
if ! [ $NO_STDIN = "true" ]; then
    declare -A COMMITS
    while read MODULE_COMMIT; do
        KEY=$(sed 's/\(^.*\)\/\/.*$/\1/' <<< "$MODULE_COMMIT")
        VALUE=$(sed 's/^.*\/\/\(.*$\)/\1/' <<< "$MODULE_COMMIT")
        COMMITS["$KEY"]="$VALUE"
    done
fi

function collect_changes() { 
    ORIGINAL_DIR=$PWD
    cd "$1"
    SUBMODULE_PATHS=$(git config --file .gitmodules --get-regexp path | awk '{print $2}')
    if ! [ $NO_STDIN = "true" ]; then
        REVISION=${COMMITS["$1"]}
    else
        REVISION=""
    fi
    CHANGED_FILES=$(git diff $REVISION --name-only)
    for FILE in $CHANGED_FILES; do
        if ! is_member $FILE "$SUBMODULE_PATHS"; then
            if [ $1 = "." ]; 
            then 
                PREFIX=""
            else 
                PREFIX="$1/"
            fi
            echo $PREFIX$FILE
        fi
    done

    for SUBMODULE in $SUBMODULE_PATHS; do
        SUBMODULE_CHANGES=$(collect_changes "$SUBMODULE")
        if ! [ -z "$SUBMODULE_CHANGES" ]; then
            echo $SUBMODULE_CHANGES
        fi
    done
    cd "$ORIGINAL_DIR"
}

collect_changes "."
