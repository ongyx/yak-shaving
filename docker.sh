#!/bin/bash
set -o errexit -o pipefail -o noclobber

DOCKER_TAG="yak-shaving-builder"

DIR="$(dirname "$(readlink -f "$0")")"

get_maintainer_from_git() {
  local name
  local email

  name="$(git config user.name)"
  email="$(git config user.email)"
  if [[ -n "$name" && -n "$email" ]]; then
    echo "$name <$email>"
  fi
}

docker_build() {
  docker build -t "$DOCKER_TAG" "$DIR"
}

docker_run() {
  docker run \
    --interactive \
    --pull never \
    --volume "${DIR}/submodules:/workdir/submodules" \
    --volume "${DIR}/cache/target:/workdir/target" \
    --volume "${DIR}/cache/registry:/usr/local/cargo/registry" \
    --volume "${DIR}/output:/workdir/output" \
    "$DOCKER_TAG:latest" \
    "$@"
}

main() {
  if [ "$#" -lt 1 ]; then
    echo "usage: $0 <steel|helix|all>" 1>&2
    exit 1
  fi

  package="$1"
  
  [[ -z "$MAINTAINER" ]] && MAINTAINER="$(get_maintainer_from_git)"

  docker_build
  docker_run bash << EOF
cd /workdir
export CARGO_TARGET_DIR="/workdir/target"
export MAINTAINER="$MAINTAINER"
export DEB_REVISION="$DEB_REVISION"
./build.sh /workdir/output "$package"
EOF
}

main "$@"

