systemctl enable --now --user podman.socket
systemctl start --user podman.socket
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
act --privileged --bind --container-daemon-socket $XDG_RUNTIME_DIR/podman/podman.sock -W .github/workflows/basic.yaml -P ubuntu-22.04=ghcr.io/catthehacker/ubuntu:act-22.04
