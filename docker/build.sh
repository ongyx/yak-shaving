#!/bin/bash
set -o errexit -o pipefail -o noclobber

DIR="$(dirname "$(readlink -f "$0")")"

RUST_TARGETS="$(grep 'ARG _RUST_TARGETS' ./Dockerfile | cut -d '=' -f2 | tr -d '"')"

DESTINATION=""

package() {
  local package
  local targets

  package="$1"
  shift
  targets="$(echo "$RUST_TARGETS" | sed -E 's/^|( )/\1--target=/g')"

  # Build package, then create the Debian package.
  # shellcheck disable=SC2086
  cargo build \
    --locked \
    --package="$package" \
    $targets \
    "$@"

  # shellcheck disable=SC2086
  cargo deb \
    --no-build \
    --color=auto \
    --section=utils \
    --package="$package" \
    --output="$DESTINATION" \
    --maintainer="$MAINTAINER" \
    --deb-revision="$DEB_REVISION" \
    $targets
}

package_steel() {
  pushd "$DIR/submodules/steel"
  for crate in steel-interpreter steel-language-server cargo-steel-lib steel-forge; do
    CARGO_PROFILE_RELEASE_DEBUG=line-tables-only package "$crate" --profile=release
  done
  popd
}

package_helix() {
  pushd "$DIR/submodules/helix"
  # Attempt to fetch and build the grammars.
  cargo run --package=helix-loader --bin=hx-loader

  # profile=opt is the profile currently used by the Actions workflow in upstream.
  package helix-term --features=steel,git --profile=opt
  popd
}

main() {
  if [ "$#" -lt 2 ]; then
    echo "usage: $0 <destination> <steel|helix>" 1>&2
    exit 1
  fi

  if [[ -z "$MAINTAINER" ]]; then
    echo "error: maintainer was not specified" 1>&2
    exit 2
  fi

  if [[ -z "$DEB_REVISION" ]]; then
    echo "error: deb revision was not specified" 1>&2
    exit 3
  fi

  DESTINATION="$1"

  case "$2" in
    "steel")
      package_steel
      ;;
    "helix")
      package_helix
      ;;
    *)
      echo "error: unknown package '$2'"
      ;;
  esac
}

main "$@"
