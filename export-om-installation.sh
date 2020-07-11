#!/bin/bash

set -eu

#########

source export-env.sh

#########

bash bbr-pipeline-tasks-repo/tasks/export-om-installation/task.sh
