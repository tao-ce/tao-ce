#!/bin/bash

cat ./Containerfile.in build/crystal/Containerfile.d/*.in > .devcontainer/Dockerfile
