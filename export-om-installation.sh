#!/bin/bash

set -xeu

#########

source export-env.sh

#########

bash bbr-pipeline-tasks-repo/tasks/export-om-installation/task.sh
