#!/bin/bash

set -eu

#########

source export-env.sh

#########

bash bbr-pipeline-tasks-repo/tasks/bbr-backup-director/task.sh
