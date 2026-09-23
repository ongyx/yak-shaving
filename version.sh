#!/bin/bash

main() {    
    local submodule_path
    local version
    
    if [ "$#" -lt 1 ]; then
        echo "usage: $0 <path to submodule>" 1>&2
        exit 1
    fi

    submodule_path="$1"
    cargo_toml_path="$submodule_path/Cargo.toml"

    if [ ! -f "$cargo_toml_path" ]; then
        echo "error: '$cargo_toml_path' does not exist" 1>&2
        exit 1
    fi

    version=$(grep "^version = " "$submodule_path/Cargo.toml" | awk -F '"' 'NF>2 {print $2}')
    # https://unix.stackexchange.com/a/640241
    date_commit=$(cd "$submodule_path" && git log -1 --date=format:%Y%m%d --pretty=%cd.%h)

    printf "%s~git%s" "$version" "$date_commit"
}

main "$@"
