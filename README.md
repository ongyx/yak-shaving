# yak-shaving

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/ongyx/yak-shaving/release.yml?label=is%20yak%20shaved)
![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fapi.github.com%2Frepos%2Fongyx%2Fyak-shaving%2Factions%2Fworkflows%2Frelease.yml%2Fruns%3Fper_page%3D1&query=%24.workflow_runs%5B%3A0%5D.run_number&label=yaks%20shaved&color=%23FFF8E7)

Personal APT repository hosting unofficial/nightly builds of software I use.

> [!note]
> This repository is *not affiliated* with the original developers.
> If you encounter issues with packaging, open an issue [here](https://github.com/ongyx/yak-shaving/issues).

Currently, these are the packages built via GitHub Actions:
- [Steel]: Scheme interpreter in Rust.
    - `steel-interpreter`
    - `steel-language-server`
    - `cargo-steel-lib`
    - `steel-forge`
- [Helix]: Steel-enabled fork of the [post-modern text editor](https://helix-editor.com).
    - `helix`

All Rust packages are built for `amd64` and `arm64` on Ubuntu 22.04, corresponding to [glibc] 2.35.
As long as you have a Debian 12/Ubuntu 22.04 install or newer the packages should work.

## Installation

1. Download the signing key:
```sh
sudo apt install wget gpg &&
wget -qO- https://ongyx.github.io/yak-shaving/public.asc | sudo gpg --dearmor -o /usr/share/keyrings/ongyx.gpg
```

2. Create a new sources file at `/etc/apt/sources.list.d/ongyx.sources`:
```
Types: deb
URIs: https://ongyx.github.io/yak-shaving
Suites: stable
Components: main
Architectures: amd64,arm64
Signed-By: /usr/share/keyrings/ongyx.gpg
```

3. Update your package cache:
```sh
sudo apt update
```

4. Install the available packages to your heart's content.

[glibc]: https://gist.github.com/richardlau/6a01d7829cc33ddab35269dacc127680
[Steel]: https://github.com/mattwparas/steel
[Helix]: https://github.com/mattwparas/helix/tree/steel-event-system