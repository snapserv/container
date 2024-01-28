variable "REGISTRY" {
    default = "localhost/snapserv/container"
}

group "default" {
    targets = [
        "base-ubuntu",
        "nginx",
    ]
}

target "docker-metadata-action" {}

target "template-base" {
    inherits = ["docker-metadata-action"]
    dockerfile = "Dockerfile"
    platforms = [
        "linux/amd64",
        "linux/arm64",
    ]
}

target "template" {
    inherits = ["template-base"]
    contexts = {
        "base-ubuntu" = "target:base-ubuntu"
    }
}

target "base-ubuntu" {
    inherits = ["template-base"]
    context = "./base-ubuntu/"
    tags = [
        "${REGISTRY}/base-ubuntu:latest",
        "${REGISTRY}/base-ubuntu:22.04",
    ]
}

target "nginx" {
    inherits = ["template"]
    context = "./nginx/"
    tags = ["${REGISTRY}/nginx:latest"]
}
