#!/bin/bash

set -o errexit
set -o pipefail

#######################
#
#     FUNCTIONS
#
#######################
usage(){
  cat <<EOF
  Usage: $(basename "$0") <COMMAND>
  Commands:
      deploy            deploy microshift cluster
  Environment variables:
      deploy
                        CLUSTER_NAME (Required) k3d cluster name.
EOF
}

panic() {
  (>&2 echo -e " - ${RED}$*${NC}")
  usage
  exit 1
}

deploy() {
  echo "it works!"
}

#######################
#
#     GUARDS SECTION
#
#######################
if [[ "$#" -lt 1 ]]; then
  usage
  exit 1
fi
if [[ -z "${NO_COLOR}" ]]; then
      YELLOW="\033[0;33m"
      CYAN="\033[1;36m"
      NC="\033[0m"
      RED="\033[0;91m"
fi

#######################
#
#     COMMANDS
#
#######################
case "$1" in
    "deploy")
       deploy
    ;;
#    "<put new command here>")
#       command_handler
#    ;;
      *)
  usage
  exit 0
  ;;
esac
