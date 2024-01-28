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
        # Use first argument as image name
        local -r image="$1"; shift

        # Split arguments based on double-dash
        local arg
        local -a docker_args=()
        local -a image_args=()

        # Split arguments into docker and image arguments
        for arg in "$@"; do
            if [[ "${arg}" == "--" ]]; then
                image_args=("${@:1}")
                break
            else
                docker_args+=("${arg}")
            fi
        done

        # Use docker to run the image
        docker run \
            --rm \
            --platform "${IMAGE_ARCH}" \
            --read-only \
            --tmpfs /run:exec \
            --tmpfs /tmp \
            -e "S6_KILL_GRACETIME=0" \
            -e "S6_READ_ONLY_ROOT=1" \
            "${docker_args[@]+"${docker_args[@]}"}" \
            "${IMAGE_REGISTRY}/${image}:latest" \
            "${image_args[@]+"${image_args[@]}"}"
    fi
}

main "$@"
