#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_PATH="$(cd "$(dirname "$0")" &>/dev/null; pwd -P)"
declare -r SCRIPT_PATH
declare -r IMAGE_REGISTRY="${IMAGE_PREFIX:-localhost/snapserv/container}"
declare -r IMAGE_ARCH="${IMAGE_ARCH:-linux/arm64}"

main() {
    # Change to script directory
    cd "${SCRIPT_PATH}"

    # Build container images
    export REGISTRY="${IMAGE_REGISTRY}"
    docker buildx bake --load --set="*.platform=${IMAGE_ARCH}"
    docker image ls | grep "${IMAGE_REGISTRY}/"

    # If an argument was specified, run the image
    if [[ $# -gt 0 ]]; then
        local -r image="$1"; shift
        docker run \
            --interactive --rm --tty \
            --platform "${IMAGE_ARCH}" \
            --read-only \
            --tmpfs /run:exec \
            --tmpfs /tmp \
            -e "S6_KILL_GRACETIME=0" \
            -e "S6_READ_ONLY_ROOT=1" \
            -p 8080:8080 \
            "${IMAGE_REGISTRY}/${image}:latest" "$@"
    fi
}

main "$@"
