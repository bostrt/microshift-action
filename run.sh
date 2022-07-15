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
                        CLUSTER_NAME (Required) microshift cluster name.
EOF
}

panic() {
  (>&2 echo -e " - ${RED}$*${NC}")
  usage
  exit 1
}

deploy() {
  sudo apt-get update
  sudo apt-get install podman git -y

  sudo podman run -d --rm --name microshift --privileged -v microshift-data:/var/lib -p 6443:6443 quay.io/microshift/microshift-aio:latest

  sudo podman exec microshift bash -c \
    'while ! test -f "/var/lib/microshift/resources/kubeadmin/kubeconfig";
    do
      echo "Waiting for kubeconfig..."
      sleep 5
    done'

  mkdir ${HOME}/.kube
  sudo podman cp microshift:/var/lib/microshift/resources/kubeadmin/kubeconfig ${HOME}/.kube/config
  sudo chown ${USER} ${HOME}/.kube/config
  chmod 600 ${HOME}/.kube/config
  sleep 10

  # Validate installation
  git clone --depth=1 https://github.com/openshift/microshift.git
  cd microshift/validate-microshift
  ./kuttl-test.sh
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
