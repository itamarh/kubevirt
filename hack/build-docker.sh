#!/bin/bash
#
# This file is part of the KubeVirt project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright 2017 Red Hat, Inc.
#

set -e

source hack/common.sh
source hack/config.sh

if [ -z "$1" ]; then
    target="build"
else
    target=$1
    shift
fi

if [ $# -eq 0 ]; then
    args=$docker_images
else
    args=$@
fi

for arg in $args; do
    BIN_NAME=$(basename $arg)
    if [ "${target}" = "build" ]; then
        (
            cd ${CMD_OUT_DIR}/${BIN_NAME}/
            docker $target -t ${docker_prefix}/${BIN_NAME}:${docker_tag} --label ${job_prefix} --label ${BIN_NAME} .
        )
    elif [ "${target}" = "push" ]; then
        (
            cd ${CMD_OUT_DIR}/${BIN_NAME}/
            docker $target ${docker_prefix}/${BIN_NAME}:${docker_tag}
        )
    fi
done
