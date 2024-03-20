#!/usr/bin/env bash

docker run --user $(id -u) -v /etc/passwd:/etc/passwd:ro -v $(realpath .):/src -w /src -i --rm docker.io/barichello/godot-ci:mono-4.2
