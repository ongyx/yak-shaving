#!/bin/bash

main() {    
    local submodule_path
    
    if [ "$#" -lt 1 ]; then
        echo "usage: $0 <path to submodule>" 1>&2
        exit 1
    fi

    submodule_path="$1"

    git diff --submodule=diff "$submodule_path" | sed '/^Submodule .* contains modified content$/d'
}

main "$@"
